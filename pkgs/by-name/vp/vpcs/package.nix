{
  lib,
  stdenv,
  fetchFromGitHub,
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vpcs";
  version = "0.8.4";

  src = fetchFromGitHub {
    owner = "GNS3";
    repo = "vpcs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sWqQDf3xqrr6k7MFXV/9K9KdsEAvftsDkGlSUhA5CmY=";
  };

  strictDeps = true;

  sourceRoot = "${finalAttrs.src.name}/src";

  makefile =
    if stdenv.hostPlatform.isDarwin then
      "Makefile.osx"
    else if stdenv.hostPlatform.isFreeBSD then
      "Makefile.fbsd"
    else if stdenv.hostPlatform.isOpenBSD then
      "Makefile.obsd"
    else
      "Makefile.linux";

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -D -m555 vpcs $out/bin/vpcs
    install -D -m444 ../man/vpcs.1 $out/share/man/man1/vpcs.1

    runHook postInstall
  '';

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
