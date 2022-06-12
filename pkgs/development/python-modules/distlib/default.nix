{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "distlib";
  version = "0.3.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e4b58818180336dc9c529bfb9a0b58728ffc09ad92027a3f30b7cd91e3458579";
    extension = "zip";
  };

  # Tests use pypi.org.
  doCheck = false;

  meta = with lib; {
    description = "Low-level components of distutils2/packaging";
    homepage = "https://distlib.readthedocs.io";
    license = licenses.psfl;
    maintainers = with maintainers; [ lnl7 ];
  };
}

