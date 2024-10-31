{ lib
, fetchFromGitLab
, buildDunePackage
, clap
, ezjsonm
, lwt
, re
}:

buildDunePackage rec {
  pname = "tezt";
  version = "4.1.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = version;
    hash = "sha256-1Cl/GOB+MDPJIl/6600PLTSL+vCYcAZGjedd6hr7rJw=";
  };

  propagatedBuildInputs = [
    clap
    ezjsonm
    lwt
    re
  ];

  meta = {
    description = "Test framework for unit tests, integration tests, and regression tests";
    license = lib.licenses.mit;
  };
}
