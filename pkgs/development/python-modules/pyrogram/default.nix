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
  version = "2.0.106";

  disabled = pythonOlder "3.7";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "pyrogram";
    repo = "pyrogram";
    rev = "v${version}";
    hash = "sha256-W/t3v5q0s+ba0Uly+JUaJl75uDQGeFaj2zDKGRMIMow=";
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
