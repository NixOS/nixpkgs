{
  lib,
  asn1crypto,
  buildPythonPackage,
  dissect-cstruct,
  dissect-fve,
  dissect-util,
  fetchFromGitHub,
  pycryptodome,
  pytestCheckHook,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dissect-apfs";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fox-it";
    repo = "dissect.apfs";
    tag = version;
    hash = "sha256-w8R8hoj3pqP0cKCd2S8jz8IRwxRp6eVN0xb0/6E2aKw=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
    dissect-fve
    dissect-cstruct
    dissect-util
    pycryptodome
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dissect.apfs" ];

  disabledTestPaths = [
    # Bad file
    "tests/test_apfs.py"
  ];

  meta = with lib; {
    description = "Dissect module implementing a parser for APFS";
    homepage = "https://github.com/fox-it/dissect.apfs";
    changelog = "https://github.com/fox-it/dissect.apfs/releases/tag/${src.tag}";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
