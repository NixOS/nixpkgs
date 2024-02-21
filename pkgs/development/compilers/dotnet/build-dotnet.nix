{ type
, version
, srcs
, packages ? null
}:

assert builtins.elem type [ "aspnetcore" "runtime" "sdk" ];
assert if type == "sdk" then packages != null else true;

{ lib
, stdenv
, fetchurl
, writeText
, autoPatchelfHook
, makeWrapper
, libunwind
, icu
, libuuid
, zlib
, libkrb5
, curl
, lttng-ust_2_12
, testers
, runCommand
, writeShellScript
, mkNugetDeps
, callPackage
, darwin
, makeSetupHook
, xmlstarlet
}:

let
  pname =
    if type == "aspnetcore" then
      "aspnetcore-runtime"
    else if type == "runtime" then
      "dotnet-runtime"
    else
      "dotnet-sdk";

  descriptions = {
    aspnetcore = "ASP.NET Core Runtime ${version}";
    runtime = ".NET Runtime ${version}";
    sdk = ".NET SDK ${version}";
  };

  mkCommon = callPackage ./common.nix {};

  _icu = if stdenv.isDarwin then darwin.ICU else icu;

  addIcuDyldPathHook = makeSetupHook {
    name = "add-icu-dyld-path-hook";
    substitutions.icu = _icu;
  } ./add-icu-dyld-path-hook.sh;

  sigtool = callPackage ./sigtool.nix {};
  signAppHost = callPackage ./sign-apphost.nix {};

in
mkCommon type rec {
  inherit pname version;

  # Some of these dependencies are `dlopen()`ed.
  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook
  ++ lib.optionals (type == "sdk" && stdenv.isDarwin) [
    xmlstarlet
    sigtool
  ];

  buildInputs = [
    stdenv.cc.cc
    zlib
    _icu
    libkrb5
    curl
  ] ++ lib.optional stdenv.isLinux lttng-ust_2_12;

  propagatedNativeBuildInputs =
    lib.optional stdenv.isDarwin addIcuDyldPathHook;

  src = fetchurl (
    srcs."${stdenv.hostPlatform.system}" or (throw
      "Missing source (url and hash) for host system: ${stdenv.hostPlatform.system}")
  );

  sourceRoot = ".";

  postPatch = if type == "sdk" && stdenv.isDarwin then ''
    xmlstarlet ed \
      --inplace \
      -s //_:Project -t elem -n Import \
      -i \$prev -t attr -n Project -v "${signAppHost}" \
      sdk/*/Sdks/Microsoft.NET.Sdk/targets/Microsoft.NET.Sdk.targets

    codesign --remove-signature packs/Microsoft.NETCore.App.Host.osx-*/*/runtimes/osx-*/native/{apphost,singlefilehost}
  '' else null;

  dontPatchELF = true;
  noDumpEnvVars = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp -r ./ $out

    mkdir -p $out/share/doc/$pname/$version
    mv $out/LICENSE.txt $out/share/doc/$pname/$version/
    mv $out/ThirdPartyNotices.txt $out/share/doc/$pname/$version/

    ln -s $out/dotnet $out/bin/dotnet

  '' + lib.optionalString stdenv.isDarwin ''
    wrapProgram $out/bin/dotnet \
      --prefix DYLD_LIBRARY_PATH : ${_icu}/lib

  '' + ''
    runHook postInstall
  '';

  # Tell autoPatchelf about runtime dependencies.
  # (postFixup phase is run before autoPatchelfHook.)
  postFixup = lib.optionalString stdenv.isLinux ''
    patchelf \
      --add-needed libicui18n.so \
      --add-needed libicuuc.so \
      $out/shared/Microsoft.NETCore.App/*/libcoreclr.so \
      $out/shared/Microsoft.NETCore.App/*/*System.Globalization.Native.so \
      $out/packs/Microsoft.NETCore.App.Host.linux-x64/*/runtimes/linux-x64/native/singlefilehost
    patchelf \
      --add-needed libgssapi_krb5.so \
      $out/shared/Microsoft.NETCore.App/*/*System.Net.Security.Native.so \
      $out/packs/Microsoft.NETCore.App.Host.linux-x64/*/runtimes/linux-x64/native/singlefilehost
    patchelf \
      --add-needed libssl.so \
      $out/shared/Microsoft.NETCore.App/*/*System.Security.Cryptography.Native.OpenSsl.so \
      $out/packs/Microsoft.NETCore.App.Host.linux-x64/*/runtimes/linux-x64/native/singlefilehost
  '';

  passthru = {
    icu = _icu;
  } // lib.optionalAttrs (type == "sdk") {
    packages = mkNugetDeps {
      name = "${pname}-${version}-deps";
      nugetDeps = packages;
    };

    updateScript =
      let
        majorVersion =
          with lib;
          concatStringsSep "." (take 2 (splitVersion version));
      in
      writeShellScript "update-dotnet-${majorVersion}" ''
        pushd pkgs/development/compilers/dotnet
        exec ${./update.sh} "${majorVersion}"
      '';
  };

  meta = with lib; {
    description = builtins.getAttr type descriptions;
    homepage = "https://dotnet.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero mdarocha ];
    mainProgram = "dotnet";
    platforms = attrNames srcs;
  };
}
