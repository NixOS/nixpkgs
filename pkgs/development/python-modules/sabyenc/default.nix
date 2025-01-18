{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "sabyenc";
  version = "3.3.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qbymi1626mmcxnsqdwnz2krxg7jvl4qbh8nwjj54z2p681wvjm4";
  };

  # tests are not included in pypi distribution
  doCheck = false;

  meta = with lib; {
    description = "Python yEnc package optimized for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabyenc/";
    license = licenses.lgpl3;
    maintainers = [ maintainers.georgewhewell ];
  };
}
