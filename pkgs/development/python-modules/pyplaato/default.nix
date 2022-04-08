{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pyplaato";
  version = "0.0.17";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fd7gHDah5yoqpH5d3bwEDsIfeflXzXevJLMD7lvz180=";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pyplaato"
  ];

  meta = with lib; {
    description = "Python API client for fetching Plaato data";
    homepage = "https://github.com/JohNan/pyplaato";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
