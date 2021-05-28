{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "sabyenc3";
  version = "4.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dfaa0bdd01752a9cfde0d349a8f4e178b04b1cf9c1bc018b287961192cd2bb90";
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
