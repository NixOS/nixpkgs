{ lib, buildPythonPackage, fetchPypi, setuptools }:

buildPythonPackage rec {
  pname = "babelfish";
  version = "0.6.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dadfadd1b205ca5fa5dc9fa637f5b7933160a0418684c7c46a7a664033208a2";
  };

  propagatedBuildInputs = [ setuptools ];

  # no tests executed
  doCheck = false;

  pythonImportsCheck = [ "babelfish" ];

  meta = with lib; {
    homepage = "https://pypi.python.org/pypi/babelfish";
    description = "A module to work with countries and languages";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
