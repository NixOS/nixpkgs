{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
, tdlib
, telegram-text
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "python-telegram";
  version = "0.18.0";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "alexander-akhmetov";
    repo = "python-telegram";
    rev = version;
    hash = "sha256-2Q0nUZ2TMVWznd05+fqYojkRn4xfFZJrlqb1PMuBsAY=";
  };

  postPatch = ''
    # Remove bundled libtdjson
    rm -fr telegram/lib

    substituteInPlace telegram/tdjson.py \
      --replace "ctypes.util.find_library(\"tdjson\")" \
                "\"${tdlib}/lib/libtdjson${stdenv.hostPlatform.extensions.sharedLibrary}\""
  '';

  propagatedBuildInputs = [
    setuptools
    telegram-text
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    "TestGetTdjsonTdlibPath"
  ];

  pythonImportsCheck = [
    "telegram.client"
  ];

  meta = with lib; {
    description = "Python client for the Telegram's tdlib";
    homepage = "https://github.com/alexander-akhmetov/python-telegram";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
