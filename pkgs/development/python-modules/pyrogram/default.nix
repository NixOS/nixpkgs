{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyaes
, pysocks
, async-lru
, tgcrypto
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyrogram";
  version = "2.0.30";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "pyrogram";
    rev = "v${version}";
    hash = "sha256-EG9LafZHqCC4klYm5gAlShnznGoaDOGsak4cEOh2OA4=";
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
