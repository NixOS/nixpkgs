{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "sabyenc";
  version = "3.3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fpvd5mckf1kbn0bhc5ybm08y41ps7sc5f9khz08qyjbikbcww85";
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
