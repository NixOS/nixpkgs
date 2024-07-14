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
    hash = "sha256-pMrNAzJXfFKk5BbBhQnd8ryep/iWN6xtZ7UaYUKsfuE=";
  };

  # tests are not included in pypi distribution
  doCheck = false;

  meta = {
    description = "Python yEnc package optimized for use within SABnzbd";
    homepage = "https://github.com/sabnzbd/sabyenc/";
    license = lib.licenses.lgpl3;
    maintainers = [ lib.maintainers.georgewhewell ];
  };
}
