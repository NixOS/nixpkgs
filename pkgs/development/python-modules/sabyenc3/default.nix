{ lib, fetchPypi, python3Packages }:

python3Packages.buildPythonPackage rec {
  pname = "sabyenc3";
  version = "5.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MIKBSPs3CtETDefiozN758hmJhdmw0UqVyG9t224tfw=";
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
