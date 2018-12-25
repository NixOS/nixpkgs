{ stdenv, fetchzip, buildDunePackage, ssl, lwt }:

buildDunePackage rec {
  pname = "lwt_ssl";
  version = "1.1.2";

  minimumOCamlVersion = "4.02";

  src = fetchzip {
    url = "https://github.com/aantron/${pname}/archive/${version}.tar.gz";
    sha256 = "1q0an3djqjxv83v3iswi7m81braqx93kcrcwrxwmf6jzhdm4pn15";
  };

  propagatedBuildInputs = [ ssl lwt ];

  meta = {
    homepage = "https://github.com/aantron/lwt_ssl";
    description = "OpenSSL binding with concurrent I/O";
    license = stdenv.lib.licenses.lgpl21;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
  };
}
