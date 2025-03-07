{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  qcheck-core,
}:

buildDunePackage rec {
  pname = "qcheck-multicoretests-util";
  version = "0.7";

  src = fetchFromGitHub {
    owner = "ocaml-multicore";
    repo = "multicoretests";
    rev = version;
    hash = "sha256-taaH+hBOdiCK2HT+5OfX892/f1ozlLdd/AteapYWK9Y=";
  };

  propagatedBuildInputs = [ qcheck-core ];

  doCheck = true;

  minimalOCamlVersion = "4.12";

  meta = {
    homepage = "https://github.com/ocaml-multicore/multicoretests";
    description = "Utility functions for property-based testing of multicore programs";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
