{ lib, fetchFromGitHub, buildDunePackage, lwt }:

buildDunePackage rec {
  pname = "lwt_log";
  version = "1.1.1";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "1n12i1rmn9cjn6p8yr6qn5dwbrwvym7ckr7bla04a1xnq8qlcyj7";
  };

  propagatedBuildInputs = [ lwt ];

  meta = {
    description = "Lwt logging library (deprecated)";
    homepage = "https://github.com/aantron/lwt_log";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
