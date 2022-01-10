{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyaes
, pysocks
, async-lru
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyrogram";
  version = "1.3.0";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "pyrogram";
    rev = "v${version}";
    sha256 = "09rxdd5bl1yby76xd3wcyrmlb4glixs637nj1w05gh2rp3gppkf8";
  };

  propagatedBuildInputs = [
    pyaes
    pysocks
    async-lru
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
