{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "sabyenc3";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0zfj1k4zij8ph8jwkq4d6i6axym8cil16yijxshqla5163d1031z";
  };

  # tests are not included in pypi distribution
  doCheck = false;

  meta = {
    description = "yEnc Decoding for Python 3";
    homepage = "https://github.com/sabnzbd/sabyenc/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.lovek323 ];
  };

}
