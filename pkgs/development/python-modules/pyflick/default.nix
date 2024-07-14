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
    hash = "sha256-cFyC2Mrt//GRF8iFnMG09W4Vq428DWTWO3nYY0AHiX8=";
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
