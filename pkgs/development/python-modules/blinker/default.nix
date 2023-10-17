{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
, pythonOlder
, setuptools
, flit-core
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "blinker";
  version = "1.6.2";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Sv095m7zqfgGdVn7ehy+VVwX3L4VlxsF0bYlw+er4hM=";
  };

  nativeBuildInputs = [
    setuptools
    flit-core
  ];

  nativeCheckInputs = [ pytestCheckHook pytest-asyncio ];

  pythonImportsCheck = [ "blinker" ];

  meta = with lib; {
    homepage = "https://github.com/pallets-eco/blinker";
    description = "Fast, simple object-to-object and broadcast signaling";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
