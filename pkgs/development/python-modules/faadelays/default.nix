{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "faadelays";
  version = "2023.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ngMFd+BE3hKeaeGEX4xHpzDIrtGFDsSwxBbrc4ZMFas=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "faadelays"
  ];

  meta = with lib; {
    changelog = "https://github.com/ntilley905/faadelays/releases/tag/v${version}";
    description = "Python package to retrieve FAA airport status";
    homepage = "https://github.com/ntilley905/faadelays";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
