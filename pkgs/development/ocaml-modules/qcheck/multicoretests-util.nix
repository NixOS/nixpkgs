{ lib, fetchFromGitHub, buildDunePackage
, qcheck-core
}:

buildDunePackage rec {
  pname = "qcheck-multicoretests-util";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ocaml-multicore";
    repo = "multicoretests";
    rev = version;
    hash = "sha256-0fbMDksC23jojJV+aegBoSwKf1hNzDUvDEbo31HUDoM=";
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
