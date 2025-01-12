{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  aiohttp,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "pyflick";
  version = "0.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "PyFlick";
    inherit version;
    sha256 = "705c82d8caedfff19117c8859cc1b4f56e15ab8dbc0d64d63b79d8634007897f";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [
    "pyflick"
    "pyflick.authentication"
  ];

  meta = with lib; {
    description = "Python API For Flick Electric in New Zealand";
    homepage = "https://github.com/ZephireNZ/PyFlick";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
