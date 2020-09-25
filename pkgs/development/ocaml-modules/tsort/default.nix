{ lib, buildDunePackage, fetchFromGitHub, containers }:

buildDunePackage rec {
  pname = "tsort";
  version = "2.0.0";
  src = fetchFromGitHub {
    owner = "dmbaturin";
    repo = "ocaml-tsort";
    rev = version;
    sha256 = "0i67ys5p5i8q9p0nhkq4pjg9jav8dy0fiy975a365j7m6bhrwgc1";
  };

  propagatedBuildInputs = [ containers ];

  meta = {
    description = "Easy to use and user-friendly topological sort";
    inherit (src.meta) homepage;
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
