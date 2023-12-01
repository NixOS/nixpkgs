{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pytest-asyncio
, setuptools
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.6.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sv095m7zqfgGdVn7ehy+VVwX3L4VlxsF0bYlw+er4hM=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "blinker"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/pallets-eco/blinker/releases/tag/${version}";
    description = "Fast Python in-process signal/event dispatching system";
    homepage = "https://github.com/pallets-eco/blinker/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
