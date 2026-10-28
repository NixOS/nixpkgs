{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchPypi,
  lxml,
}:

buildPythonPackage rec {
  pname = "pykmtronic";
  version = "0.4.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-RRB4NxDzXCfaPSnc8FJF8ikGqnAzfHkS6Nasjr3Y4qk=";
  };

  propagatedBuildInputs = [
    aiohttp
    lxml
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "pykmtronic" ];

  meta = {
    description = "Python client to interface with KM-Tronic web relays";
    homepage = "https://github.com/dgomes/pykmtronic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
