{ lib, fetchFromGitHub, buildDunePackage
, qcheck-core
}:

buildDunePackage rec {
  pname = "qcheck-multicoretests-util";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "ocaml-multicore";
    repo = "multicoretests";
    rev = version;
    hash = "sha256-5UyQs99x2CWK9ncsRwdvA5iGhry9JnMs5nKoFSRHg3M=";
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
