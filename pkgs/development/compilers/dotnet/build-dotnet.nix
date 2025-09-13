{
  type,
  version,
  srcs,
  commonPackages ? null,
  hostPackages ? null,
  targetPackages ? null,
  runtime ? null,
  aspnetcore ? null,
}:

assert builtins.elem type [
  "aspnetcore"
  "runtime"
  "sdk"
];
assert
  if type == "sdk" then
    commonPackages != null
    && hostPackages != null
    && targetPackages != null
    && runtime != null
    && aspnetcore != null
  else
    true;

{
  lib,
  stdenv,
  fetchurl,
  writeText,
  autoPatchelfHook,
  makeWrapper,
  libunwind,
  icu,
  libuuid,
  zlib,
  libkrb5,
  openssl,
  curl,
  lttng-ust_2_12,
  testers,
  runCommand,
  writeShellScript,
  mkNugetDeps,
  callPackage,
  systemToDotnetRid,
  xmlstarlet,
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

  mkWrapper = callPackage ./wrapper.nix { };

  hostRid = systemToDotnetRid stdenv.hostPlatform.system;
  targetRid = systemToDotnetRid stdenv.targetPlatform.system;

  sigtool = callPackage ./sigtool.nix { };
  signAppHost = callPackage ./sign-apphost.nix { };

  hasILCompiler = lib.versionAtLeast version (if hostRid == "osx-arm64" then "8" else "7");

  extraTargets = writeText "extra.targets" (
    ''
      <Project>
    ''
    + lib.optionalString hasILCompiler ''
      <ItemGroup>
        <CustomLinkerArg Include="-Wl,-rpath,'${
          lib.makeLibraryPath [
            icu
            zlib
            openssl
          ]
        }'" />
      </ItemGroup>
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      <Import Project="${signAppHost}" />
    ''
    + ''
      </Project>
    ''
  );

in
mkWrapper type (
  stdenv.mkDerivation (finalAttrs: {
    inherit pname version;

    # Some of these dependencies are `dlopen()`ed.
    nativeBuildInputs = [
      makeWrapper
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux autoPatchelfHook
    ++ lib.optionals (type == "sdk" && stdenv.hostPlatform.isDarwin) [
      xmlstarlet
      sigtool
    ];

    buildInputs = [
      stdenv.cc.cc
      zlib
      icu
      libkrb5
      curl
      xmlstarlet
    ]
    ++ lib.optional stdenv.hostPlatform.isLinux lttng-ust_2_12;

    src = fetchurl (
      srcs.${hostRid} or (throw "Missing source (url and hash) for host RID: ${hostRid}")
    );

    sourceRoot = ".";

    postPatch =
      if type == "sdk" then
        (
          ''
            xmlstarlet ed \
              --inplace \
              -s //_:Project -t elem -n Import \
              -i \$prev -t attr -n Project -v "${extraTargets}" \
              sdk/*/Sdks/Microsoft.NET.Sdk/targets/Microsoft.NET.Sdk.targets
          ''
          + lib.optionalString (stdenv.hostPlatform.isDarwin && lib.versionOlder version "10") ''
            codesign --remove-signature packs/Microsoft.NETCore.App.Host.osx-*/*/runtimes/osx-*/native/{apphost,singlefilehost}
          ''
        )
      else
        null;

    dontPatchELF = true;
    noDumpEnvVars = true;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/doc/$pname/$version
      mv LICENSE.txt $out/share/doc/$pname/$version/
      mv ThirdPartyNotices.txt $out/share/doc/$pname/$version/

      mkdir -p $out/share/dotnet
      cp -r ./ $out/share/dotnet

      mkdir -p $out/bin
      ln -s $out/share/dotnet/dotnet $out/bin/dotnet

      runHook postInstall
    '';

    # Tell autoPatchelf about runtime dependencies.
    # (postFixup phase is run before autoPatchelfHook.)
    postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
      patchelf \
        --add-needed libicui18n.so \
        --add-needed libicuuc.so \
        $out/share/dotnet/shared/Microsoft.NETCore.App/*/libcoreclr.so \
        $out/share/dotnet/shared/Microsoft.NETCore.App/*/*System.Globalization.Native.so \
        $out/share/dotnet/packs/Microsoft.NETCore.App.Host.${hostRid}/*/runtimes/${hostRid}/native/*host
      patchelf \
        --add-needed libgssapi_krb5.so \
        $out/share/dotnet/shared/Microsoft.NETCore.App/*/*System.Net.Security.Native.so \
        $out/share/dotnet/packs/Microsoft.NETCore.App.Host.${hostRid}/*/runtimes/${hostRid}/native/*host
      patchelf \
        --add-needed libssl.so \
        $out/share/dotnet/shared/Microsoft.NETCore.App/*/*System.Security.Cryptography.Native.OpenSsl.so \
        $out/share/dotnet/packs/Microsoft.NETCore.App.Host.${hostRid}/*/runtimes/${hostRid}/native/*host
    '';

    # fixes: Could not load ICU data. UErrorCode: 2
    propagatedSandboxProfile = lib.optionalString stdenv.hostPlatform.isDarwin ''
      (allow file-read* (subpath "/usr/share/icu"))
      (allow file-read* (subpath "/private/var/db/mds/system"))
      (allow mach-lookup (global-name "com.apple.SecurityServer")
                         (global-name "com.apple.system.opendirectoryd.membership"))
    '';

    passthru = {
      inherit icu hasILCompiler;
    }
    // lib.optionalAttrs (type == "sdk") (
      let
        # force evaluation of the SDK package to ensure evaluation failures
        # (e.g. due to vulnerabilities) propagate to the nuget packages
        forceSDKEval = builtins.seq finalAttrs.finalPackage.drvPath;
      in
      {
        packages = map forceSDKEval (
          commonPackages ++ hostPackages.${hostRid} ++ targetPackages.${targetRid}
        );
        targetPackages = lib.mapAttrs (_: map forceSDKEval) targetPackages;
        inherit runtime aspnetcore;

        updateScript =
          let
            majorVersion = lib.concatStringsSep "." (lib.take 2 (lib.splitVersion version));
          in
          [
            ./update.sh
            majorVersion
          ];
      }
    );

    meta = with lib; {
      description = builtins.getAttr type descriptions;
      homepage = "https://dotnet.github.io/";
      license = licenses.mit;
      maintainers = with maintainers; [
        kuznero
        mdarocha
        corngood
      ];
      mainProgram = "dotnet";
      platforms = lib.filter (
        platform:
        let
          e = builtins.tryEval (systemToDotnetRid platform);
        in
        e.success && srcs ? "${e.value}"
      ) lib.platforms.all;
      sourceProvenance = with lib.sourceTypes; [
        binaryBytecode
        binaryNativeCode
      ];
      knownVulnerabilities =
        lib.optionals
          (lib.elem (lib.head (lib.splitVersion version)) [
            "6"
            "7"
          ])
          [
            "Dotnet SDK ${version} is EOL, please use 8.0 (LTS) or 9.0 (Current)"
          ];
    };
  })
)
