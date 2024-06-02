{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  sybil,
  numpy,
  ipython,
  hatchling,
  beartype,
  rich,
  typing-extensions,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "plum-dispatch";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beartype";
    repo = "plum";
    rev = "refs/tags/v${version}";
    hash = "sha256-q235pinc9B1YgA2/HUIldEwEO7uIgMg7lcd9Ogfd3LQ=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    beartype
    rich
    typing-extensions
  ];

  nativeCheckInputs = [
    sybil
    numpy
    ipython
    pytestCheckHook
    pytest-cov
  ];

  pythonImportsCheck = [ "plum" ];

  meta = {
    description = "Multiple dispatch in Python";
    homepage = "https://github.com/beartype/plum";
    changelog = "https://github.com/beartype/plum/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
  };
}
