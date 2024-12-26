{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "violet";
  version = "0.5.1";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "violet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xy6eo0BOKlUb6SN3mU8Nc85cW+I93pKl7N1bXoSOYUI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Lightweight STUN/TURN server";
    homepage = "https://github.com/paullouisageneau/violet";
    license = lib.licenses.gpl2Only;
    mainProgram = "violet";
    maintainers = with lib.maintainers; [ oluceps ];
    platforms = lib.platforms.all;
  };
})
