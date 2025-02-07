{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools-scm,
  setuptools,
  tdlib,
  telegram-text,
}:

buildPythonPackage rec {
  pname = "python-telegram";
  version = "0.19.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "alexander-akhmetov";
    repo = "python-telegram";
    tag = version;
    hash = "sha256-JnU59DZXpnaZXIY/apXQ2gBgiwT12rJIeVqzaP0l7Zk=";
  };

  postPatch = ''
    # Remove bundled libtdjson
    rm -fr telegram/lib

    substituteInPlace telegram/tdjson.py \
      --replace-fail "ctypes.util.find_library(\"tdjson\")" \
                "\"${tdlib}/lib/libtdjson${stdenv.hostPlatform.extensions.sharedLibrary}\""
  '';

  build-inputs = [ setuptools ];

  dependencies = [
    setuptools-scm
    telegram-text
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [ "TestGetTdjsonTdlibPath" ];

  pythonImportsCheck = [ "telegram.client" ];

  meta = with lib; {
    description = "Python client for the Telegram's tdlib";
    homepage = "https://github.com/alexander-akhmetov/python-telegram";
    changelog = "https://github.com/alexander-akhmetov/python-telegram/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
  };
}
