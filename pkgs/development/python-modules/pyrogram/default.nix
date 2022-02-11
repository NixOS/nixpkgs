{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, pyaes
, pysocks
, async-lru
, tgcrypto
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyrogram";
  version = "1.4.3";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "Pyrogram";
    inherit version;
    hash = "sha256-5twH9ZfwtP6gi50K8nqXOmCPSFkHO5Hitd7XaDP0EQg=";
  };

  propagatedBuildInputs = [
    pyaes
    pysocks
    async-lru
    tgcrypto
  ];

  checkInputs = [
    pytestCheckHook
    pytest-asyncio
  ];

  pythonImportsCheck = [
    "pyrogram"
    "pyrogram.errors"
    "pyrogram.types"
  ];

  meta = with lib; {
    description = "Telegram MTProto API Client Library and Framework for Python";
    homepage = "https://github.com/pyrogram/pyrogram";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
