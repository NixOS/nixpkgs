{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  clap,
  ezjsonm,
  lwt,
  re,
}:

buildDunePackage rec {
  pname = "tezt";
  version = "4.2.0";

  minimalOCamlVersion = "4.12";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = pname;
    rev = version;
    hash = "sha256-8+q/A1JccH3CfWxfNhgJU5X+KEp+Uw7nvS72ZcPRsd8=";
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
