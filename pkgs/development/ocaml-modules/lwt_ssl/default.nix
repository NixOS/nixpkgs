{ lib, fetchzip, buildDunePackage, ssl, lwt }:

buildDunePackage rec {
  pname = "lwt_ssl";
  version = "1.1.3";

  minimumOCamlVersion = "4.02";
  useDune2 = true;

  src = fetchzip {
    url = "https://github.com/aantron/${pname}/archive/${version}.tar.gz";
    sha256 = "0v417ch5zn0yknj156awa5mrq3mal08pbrvsyribbn63ix6f9y3p";
  };

  propagatedBuildInputs = [ ssl lwt ];

  meta = {
    homepage = "https://github.com/aantron/lwt_ssl";
    description = "OpenSSL binding with concurrent I/O";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
