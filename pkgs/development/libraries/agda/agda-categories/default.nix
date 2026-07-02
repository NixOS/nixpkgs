{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  version = "0.3.0";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "sha256-/3e8CkaTr0bUBgzhjAvu2RV6y0gk77VRA4PE6vutKPc=";
  };

  postPatch = ''
    # Remove this once agda-categories incorporates this fix or once Agda's
    # versioning system gets an overhaul in general. Right now there is no middle
    # ground between "no version constraint" and "exact match down to patch". We
    # do not want to need to change this postPatch directive on each minor
    # version update of the stdlib, so we get rid of the version constraint
    # altogether.
    sed -Ei 's/standard-library-[0-9.]+/standard-library/' agda-categories.agda-lib
  '';

  buildInputs = [ standard-library ];

  meta = {
    inherit (src.meta) homepage;
    description = "New Categories library";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      alexarice
      turion
    ];
  };
}
