{ lib, fetchurl, buildDunePackage, ssl, lwt }:

buildDunePackage rec {
  pname = "lwt_ssl";
  version = "1.2.0";

  duneVersion = "3";

  src = fetchurl {
    url = "https://github.com/ocsigen/lwt_ssl/releases/download/${version}/lwt_ssl-${version}.tbz";
    hash = "sha256-swIK0nrs83fhw/J0Cgizbcu6mR+EMGZRE1dBBUiImnc=";
  };

  propagatedBuildInputs = [ ssl lwt ];

  meta = {
    homepage = "https://github.com/aantron/lwt_ssl";
    description = "OpenSSL binding with concurrent I/O";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
