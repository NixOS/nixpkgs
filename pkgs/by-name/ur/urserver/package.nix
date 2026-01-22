{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  bluez,
  libX11,
  libXtst,
  makeWrapper,
  versionCheckHook,
}:
stdenv.mkDerivation (
  finalAttrs:
  let
    sources = {
      "x86_64-linux" = {
        url = "https://www.unifiedremote.com/static/builds/server/linux-x64/${builtins.elemAt (builtins.splitVersion finalAttrs.version) 3}/urserver-${finalAttrs.version}.tar.gz";
        hash = "sha256-4wA2VPb5QN30TWa72pUVTYfvsxlGTO8Vngh7wDHXhDE=";
      };
      "aarch64-linux" = {
        url = "https://www.unifiedremote.com/static/builds/server/linux-arm64/${builtins.elemAt (builtins.splitVersion finalAttrs.version) 3}/urserver-${finalAttrs.version}.tar.gz";
        hash = "sha256-GmYekCGb64GdFdABEJl9CgqycnsBX95W9/b0xZJntEs=";
      };
    };
  in

  {
    pname = "urserver";
    version = "3.14.0.2574";

    src =
      let
        platformSource =
          sources."${stdenv.hostPlatform.system}"
            or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
      in
      fetchurl {
        inherit (platformSource) url hash;
      };

    nativeBuildInputs = [
      autoPatchelfHook
      makeWrapper
    ];

    buildInputs = [ (lib.getLib stdenv.cc.cc) ];

    installPhase = ''
      install -m755 -D urserver $out/bin/urserver
      wrapProgram $out/bin/urserver --prefix LD_LIBRARY_PATH : "${
        lib.makeLibraryPath [
          libX11
          libXtst
          bluez
        ]
      }"
      cp -r remotes $out/bin/remotes
      cp -r manager $out/bin/manager
    '';

    nativeInstallCheckInputs = [ versionCheckHook ];
    doInstallCheck = true;

    meta = {
      homepage = "https://www.unifiedremote.com/";
      description = "One-and-only remote for your computer";
      sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
      license = lib.licenses.unfree;
      maintainers = with lib.maintainers; [ sfrijters ];
      platforms = lib.attrNames sources;
      mainProgram = "urserver";
    };
  }
)
