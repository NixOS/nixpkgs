{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  pytestCheckHook,

  pythonOlder,

  setuptools,
  wheel,
  setuptools-scm,

  # for tests
  base58,

  typing-extensions,
  typing-validation,
}:

buildPythonPackage rec {
  pname = "bases";
  version = "0.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hashberg-io";
    repo = "bases";
    rev = "refs/tags/v${version}";
    hash = "sha256-CRXVxT9uYud1CKRcdRAD0OX5sTAttrUO9E4BaavTe6A=";
  };

  build-system = [
    setuptools
    wheel
    setuptools-scm
  ];

  dependencies = [
    typing-extensions
    typing-validation
  ];

  nativeCheckInputs = [
    pytestCheckHook
    base58
  ];

  pythonImportsCheck = [
    "bases"
    "bases.alphabet"
    "bases.alphabet.abstract"
    "bases.alphabet.range_alphabet"
    "bases.alphabet.string_alphabet"
    "bases.encoding"
    "bases.encoding.base"
    "bases.encoding.block"
    "bases.encoding.errors"
    "bases.encoding.fixchar"
    "bases.encoding.simple"
    "bases.encoding.zeropad"
    "bases.random"
  ];

  meta = {
    description = "Python library for general Base-N encodings";
    homepage = "https://github.com/hashberg-io/bases";
    changelog = "https://github.com/hashberg-io/bases/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vizid ];
  };
}
