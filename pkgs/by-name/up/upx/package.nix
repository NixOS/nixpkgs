{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upx";
  version = "5.0.1";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-Tkyhr9iuyD2EnVZgo2X/NF0Am12JEZ3vQ9ojOjqsZ2E=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "Ultimate Packer for eXecutables";
    changelog = "https://github.com/upx/upx/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "upx";
  };
})
