{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.16.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926";
  };

  doCheck = false;

  meta = {
    description = "Python 2 and 3 compatibility library";
    homepage = "https://pypi.python.org/pypi/six/";
    license = lib.licenses.mit;
  };
}
