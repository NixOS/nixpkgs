{
  lib,
  mkDerivation,
  fetchFromGitHub,
  standard-library,
}:

mkDerivation rec {
  version = "0.2.0";
  pname = "agda-categories";

  src = fetchFromGitHub {
    owner = "agda";
    repo = "agda-categories";
    rev = "v${version}";
    sha256 = "sha256-GQuQxzYSQxAIVSJ1vf0blRC0juoxAqD1AHW66H/6NSk=";
  };

  postPatch = ''
    # Remove this once agda-categories incorporates this fix or once Agda's
    # versioning system gets an overhaul in general. Right now there is no middle
    # ground between "no version constraint" and "exact match down to patch". We
    # do not want to need to change this postPatch directive on each minor
    # version update of the stdlib, so we get rid of the version constraint
    # altogether.
    sed -Ei 's/standard-library-[0-9.]+/standard-library/' agda-categories.agda-lib

    # The Makefile of agda-categories uses git(1) instead of find(1) to
    # determine the list of source files. We cannot use git, as $PWD will not
    # be a valid Git working directory.
    find src -name '*.agda' | sed -e 's|^src/[/]*|import |' -e 's|/|.|g' -e 's/.agda//' -e '/import Everything/d' | LC_COLLATE='C' sort > Everything.agda
  '';

  buildInputs = [ standard-library ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "New Categories library";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      alexarice
      turion
    ];
  };
}
