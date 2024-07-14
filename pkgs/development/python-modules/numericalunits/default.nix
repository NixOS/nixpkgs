{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
}:

buildPythonPackage rec {
  version = "1.25";
  format = "setuptools";
  pname = "numericalunits";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wypIKtroGKGo1seZv5+xUzJkYdSQwN6d6rnGlKZTfuw=";
  };

  disabled = !isPy3k;

  meta = with lib; {
    homepage = "http://pypi.python.org/pypi/numericalunits";
    description = "Package that lets you define quantities with unit";
    license = licenses.mit;
    maintainers = [ ];
  };
}
