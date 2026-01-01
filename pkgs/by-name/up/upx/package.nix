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
  version = "5.0.2";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-ntnOuraEFVIU4dVE2oumpxBmzNNGjqrwMrQFaJp/zww=";
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests.version = testers.testVersion { package = finalAttrs.finalPackage; };
  };

<<<<<<< HEAD
  meta = {
    homepage = "https://upx.github.io/";
    description = "Ultimate Packer for eXecutables";
    changelog = "https://github.com/upx/upx/blob/${finalAttrs.src.rev}/NEWS";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    homepage = "https://upx.github.io/";
    description = "Ultimate Packer for eXecutables";
    changelog = "https://github.com/upx/upx/blob/${finalAttrs.src.rev}/NEWS";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "upx";
  };
})
