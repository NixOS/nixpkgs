{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pytest-mypy
, pytestCheckHook
, pythonOlder
, types-setuptools
}:

buildPythonPackage rec {
  pname = "pytest-aio";
  version = "1.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ZPG6k+ZNi6FQftIVwr/Lux5rJlo284V/mjtYepNScdQ=";
  };

  buildInputs = [
    pytest
  ];

  checkInputs = [
    pytest-mypy
    pytestCheckHook
    types-setuptools
  ];

  pythonImportsCheck = [
    "pytest_aio"
  ];

  meta = with lib; {
    homepage = "https://github.com/klen/pytest-aio";
    description = "Pytest plugin for aiohttp support";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
