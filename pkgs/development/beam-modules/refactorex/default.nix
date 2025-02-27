{
  lib,
  fetchFromGitHub,
  beamPackages,
  ...
}:
beamPackages.mixRelease rec {
  pname = "refactorex";
  version = "0.1.43";

  src = fetchFromGitHub {
    owner = "gp-pereira";
    repo = "refactorex";
    rev = version;
    hash = "sha256-fWLLpRLfY5i+8VL1iDzlXO3czvE0dGDGP4WTfBpognM=";
  };

  mixNixDeps = import ./mix.nix {
    inherit beamPackages lib;
  };

  removeCookie = false;

  meta = with lib; {
    description = "Elixir refactoring tool";
    homepage = "https://github.com/gp-pereira/refactorex";
    license = licenses.mit;
    maintainers = with maintainers; [ phrmendes ];
    platforms = platforms.unix;
    mainProgram = "refactorex";
  };
}
