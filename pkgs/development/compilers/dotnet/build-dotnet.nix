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

  packageDeps = if type == "sdk" then mkNugetDeps {
    name = "${pname}-${version}-deps";
    nugetDeps = packages;
  } else null;

in
stdenv.mkDerivation (finalAttrs: rec {
  inherit pname version;

  # Some of these dependencies are `dlopen()`ed.
  nativeBuildInputs = [
    makeWrapper
  ] ++ lib.optional stdenv.isLinux autoPatchelfHook;

  buildInputs = [
    stdenv.cc.cc
    zlib
    icu
    libkrb5
    curl
  ] ++ lib.optional stdenv.isLinux lttng-ust_2_12;

  src = fetchurl (
    srcs."${stdenv.hostPlatform.system}" or (throw
      "Missing source (url and hash) for host system: ${stdenv.hostPlatform.system}")
  );

  sourceRoot = ".";

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

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/dotnet --info
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

  setupHook = writeText "dotnet-setup-hook" ''
    if [ ! -w "$HOME" ]; then
      export HOME=$(mktemp -d) # Dotnet expects a writable home directory for its configuration files
    fi

    export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1 # Dont try to expand NuGetFallbackFolder to disk
    export DOTNET_NOLOGO=1 # Disables the welcome message
    export DOTNET_CLI_TELEMETRY_OPTOUT=1
  '';

  passthru = {
    inherit icu;
    packages = packageDeps;

    updateScript =
      if type == "sdk" then
      let
        majorVersion =
          with lib;
          concatStringsSep "." (take 2 (splitVersion version));
      in
      writeShellScript "update-dotnet-${majorVersion}" ''
        pushd pkgs/development/compilers/dotnet
        exec ${./update.sh} "${majorVersion}"
      '' else null;

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      smoke-test = runCommand "dotnet-sdk-smoke-test" {
        nativeBuildInputs = [ finalAttrs.finalPackage ];
      } ''
        HOME=$(pwd)/fake-home
        dotnet new console
        dotnet build
        output="$(dotnet run)"
        # yes, older SDKs omit the comma
        [[ "$output" =~ Hello,?\ World! ]] && touch "$out"
      '';
    };
  };

  meta = with lib; {
    description = builtins.getAttr type descriptions;
    homepage = "https://dotnet.github.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ kuznero mdarocha ];
    mainProgram = "dotnet";
    platforms = attrNames srcs;
  };
})
