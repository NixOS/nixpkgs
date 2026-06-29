{
  buildOctavePackage,
  lib,
  fetchFromGitHub,
}:

buildOctavePackage rec {
  pname = "octave_tar";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "CNOCTAVE";
    repo = "octave_tar";
    tag = version;
    sha256 = "sha256-uUZnlLeCNUy2LTK+qg9jPQal5IbicKod0hnZ/g8wCyY=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/octave_tar/";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    description = "The octave_tar package provides functions for pack and unpack about tar format.";
  };
}
