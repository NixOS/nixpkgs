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
  version = "5.1.0";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-FQtDHsbZ/JrgRLwc2Wd2F5ZcBdqrU0YIT9hGQ0k0D+w=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    homepage = "https://upx.github.io/";
    description = "Ultimate Packer for eXecutables";
    changelog = "https://github.com/upx/upx/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "upx";
  };
})
