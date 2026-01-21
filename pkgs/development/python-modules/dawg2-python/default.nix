{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  typing-extensions,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "dawg2-python";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pymorphy2-fork";
    repo = "DAWG-Python";
    tag = version;
    hash = "sha256-45k7QmozbMt7qYdDFRSL5JDeEtqdMHBoEXXQkLDoGfE=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "dawg_python"
  ];

  meta = {
    description = "Pure-python reader for DAWGs created by dawgdic C++ library or DAWG Python extension. Fork of  https://github.com/pytries/DAWG-Python";
    homepage = "https://github.com/pymorphy2-fork/DAWG-Python";
    changelog = "https://github.com/pymorphy2-fork/DAWG-Python/blob/${src.tag}/CHANGES.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
