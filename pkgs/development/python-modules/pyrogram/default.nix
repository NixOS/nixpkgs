{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pyaes
, pysocks
, pytestCheckHook
, pytest-asyncio
}:

buildPythonPackage rec {
  pname = "pyrogram";
  version = "2.0.62";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "pyrogram";
    rev = "v${version}";
    hash = "sha256-Kex9xIjcAYCzHeqWoDAIgTMuih0s42/O2zfTYxWEqbM=";
  };

  propagatedBuildInputs = [
    pyaes
    pysocks
  ];

  nativeCheckInputs = [
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
