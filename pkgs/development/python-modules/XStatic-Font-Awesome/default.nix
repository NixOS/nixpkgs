{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "XStatic-Font-Awesome";
  version = "4.7.0.0";


  src = fetchPypi {
    inherit pname version;
    sha256 = "e01fb480caaa7c7963dcb3328a4700e631bef6070db0e8b685816d220e685f6c";
  };

  doCheck = false; # pypi version doesn't include tests

  meta = {
    description = "Font Awesome icons packaged for setuptools";
    longDescription = ''
        Font Awesome icons packaged for setuptools
    '';
    homepage = "https://opendev.org/openstack/xstatic-font-awesome";
    license = lib.licenses.ofl;
  };
}
