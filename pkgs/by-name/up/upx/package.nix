{ lib
, stdenv
, fetchFromGitHub
, cmake
, nix-update-script
, testers
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "upx";
  version = "4.2.4";
  src = fetchFromGitHub {
    owner = "upx";
    repo = "upx";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-r36BD5f/sQSz3GjvreOptc7atIaaBZKpU+7qm+BKLss=";
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
