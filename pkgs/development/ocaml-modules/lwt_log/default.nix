{ stdenv, fetchFromGitHub, buildDunePackage, lwt }:

buildDunePackage rec {
  pname = "lwt_log";
  version = "1.1.0";

  minimumOCamlVersion = "4.02";

  src = fetchFromGitHub {
    owner = "aantron";
    repo = pname;
    rev = version;
    sha256 = "1c58gkqfvyf2j11jwj2nh4iq999wj9xpnmr80hz9d0nk9fv333pi";
  };

  propagatedBuildInputs = [ lwt ];

  meta = {
    description = "Lwt logging library (deprecated)";
    homepage = "https://github.com/aantron/lwt_log";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
