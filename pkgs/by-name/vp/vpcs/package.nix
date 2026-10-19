{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpcs";
  version = "0.8.4";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "vpcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sWqQDf3xqrr6k7MFXV/9K9KdsEAvftsDkGlSUhA5CmY=";
  };

  sourceRoot = "${finalAttrs.src.name}/src";

  buildPhase = ''
    runHook preBuild

    MKOPT="CC=${stdenv.cc.targetPrefix}cc" ./mk.sh ${stdenv.buildPlatform.linuxArch}

    runHook postBuild
  '';

  postInstall = ''
    install -D -m555 vpcs $out/bin/vpcs
    install -D -m444 ../man/vpcs.1 $out/share/man/man1/vpcs.1
  '';

  enableParallelBuilding = true;

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "-v";
  doInstallCheck = true;

  meta = {
    description = "Simple virtual PC simulator";
    longDescription = ''
      The VPCS (Virtual PC Simulator) can simulate up to 9 PCs. You can
      ping/traceroute them, or ping/traceroute the other hosts/routers from the
      VPCS when you study the Cisco routers in the dynamips.
    '';
    homepage = "https://github.com/GNS3/vpcs";
    changelog = "https://github.com/GNS3/vpcs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "vpcs";
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
})
