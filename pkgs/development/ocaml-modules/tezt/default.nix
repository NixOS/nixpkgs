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
  version = "4.3.0";

  minimalOCamlVersion = "4.13";

  src = fetchFromGitLab {
    owner = "nomadic-labs";
    repo = "tezt";
    tag = version;
    hash = "sha256-BF+hNqTm9r2S3jGjmjrw+/SHrr87WSe4YUjkc9WRgNo=";
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
