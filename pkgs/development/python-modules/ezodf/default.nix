{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  lxml,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "ezodf";
  version = "0.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "T0ha";
    repo = "ezodf";
    tag = version;
    hash = "sha256-d66CTj9CpCnMICqNdUP07M9elEfoxuPg8x1kxqgXTTE=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    lxml
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlags = [
    "tests"
  ];

  pythonImportsCheck = [
    "ezodf"
  ];

  meta = {
    description = "Extract, add, modify, or delete document data in OpenDocument (ODF) files";
    homepage = "https://github.com/T0ha/ezodf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zhaofengli ];
  };
}
