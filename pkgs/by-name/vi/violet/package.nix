{
  lib,
  cmake,
  fetchFromGitHub,
  nix-update-script,
  stdenv,
  violet,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "violet";
  version = "0.4.6";

  src = fetchFromGitHub {
    owner = "paullouisageneau";
    repo = "violet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-a/WRFr6C6MWQBAG0PIDdSRVd4wnQgchPeTMoxUa2Qus=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = nix-update-script { };
    tests = testers.testVersion { package = violet; };
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
