{ lib
, aiohttp
, buildPythonPackage
, cryptography
, fetchPypi
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pymazda";
  version = "0.3.11";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-DiXLY4mfgRbE0Y1tOJnkMSQQj1vcySLVDBthOWe7/dM=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    cryptography
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pymazda"
  ];

  meta = with lib; {
    description = "Python client for interacting with the MyMazda API";
    homepage = "https://github.com/bdr99/pymazda";
    changelog = "https://github.com/bdr99/pymazda/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
