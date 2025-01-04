{
  lib,
  fetchPypi,
  buildPythonPackage,
}:
buildPythonPackage rec {
  pname = "banal";
  version = "1.0.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2fe02c9305f53168441948f4a03dfbfa2eacc73db30db4a93309083cb0e250a5";
  };

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "banal" ];

  meta = with lib; {
    description = "Commons of banal micro-functions for Python";
    homepage = "https://github.com/pudo/banal";
    license = licenses.mit;
    maintainers = [ ];
  };
}
