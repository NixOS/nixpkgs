{
  lib,
  fetchFromGitHub,
  buildDunePackage,
  lwt,
}:

buildDunePackage rec {
  pname = "lwt_log";
  version = "1.1.2";

  minimalOCamlVersion = "4.03";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "sha256-ODTD3KceEnrEzD01CeuNg4BNKOtKZEpYaDIB+RIte1U=";
  };

  propagatedBuildInputs = [ lwt ];

  meta = {
    description = "Lwt logging library (deprecated)";
    homepage = "https://github.com/aantron/lwt_log";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
