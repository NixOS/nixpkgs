{ lib
, buildPythonPackage
, fetchPypi
, fetchpatch
, pythonOlder

# build
, poetry-core

# propagates
, aiohttp
, pydantic
, toml

# tests
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

let
  pname = "kanidm";
  version = "0.0.3";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sTkAKxtJa7CVYKuXC//eMmf3l8ABsrEr2mdf1r2Gf9A=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    aiohttp
    pydantic
    toml
  ];

  checkInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-m 'not network'"
  ];

  pythonImportsCheck = [
    "kanidm"
  ];

  meta = with lib; {
    description = "Kanidm client library";
    homepage = "https://github.com/kanidm/kanidm/tree/master/pykanidm";
    license = licenses.mpl20;
    maintainers = with maintainers; [ arianvp hexa ];
  };
}
