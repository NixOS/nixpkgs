{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  python-dateutil,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pyplaato";
  version = "0.0.19";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hu45sofG7QiWZVCE1JrZZMBXWmQ/v0sK8QJlN+VBe+U=";
  };

  propagatedBuildInputs = [
    aiohttp
    python-dateutil
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyplaato" ];

  meta = with lib; {
    description = "Python API client for fetching Plaato data";
    homepage = "https://github.com/JohNan/pyplaato";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
