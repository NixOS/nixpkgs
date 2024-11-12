{
  lib,
  fetchurl,
  stdenvNoCC,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vfkit";
  version = "0.5.1";

  src = fetchurl {
    url = "https://github.com/crc-org/vfkit/releases/download/v${finalAttrs.version}/vfkit";
    hash = "sha256-at+KsvsKO359d4VUvcSuio2ej5hM6//U4Mj/jqXwhEc=";
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 $src $out/bin/vfkit

    runHook postInstall
  '';

  passthru.tests = {
    version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Simple command line tool to start VMs through the macOS Virtualization framework";
    homepage = "https://github.com/crc-org/vfkit";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    platforms = lib.platforms.darwin;
    # Source build will be possible after darwin SDK 12.0 bump
    # https://github.com/NixOS/nixpkgs/pull/229210
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    mainProgram = "vfkit";
  };
})
