{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
  tdlib,
  telegram-text,
}:

buildPythonPackage rec {
  pname = "python-telegram";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alexander-akhmetov";
    repo = "python-telegram";
    tag = version;
    hash = "sha256-0Bjqb0F6iJcmgHF4aDmNV26ZpkPf18ZbYKIBJfQLnt8=";
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

  meta = {
    description = "Python client for the Telegram's tdlib";
    homepage = "https://github.com/alexander-akhmetov/python-telegram";
    changelog = "https://github.com/alexander-akhmetov/python-telegram/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
