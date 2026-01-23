{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  emoji,
  python-yakh,
  questo,
  rich,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "beaupy";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "beaupy";
    rev = "v${version}";
    hash = "sha256-EQekSvjhL2qVQTjbdv4OqYMRUXrS9VzAIWiDjGdy3Rc=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    emoji
    python-yakh
    questo
    rich
  ];

  pythonImportsCheck = [
    "beaupy"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Python library of interactive CLI elements you have been looking for";
    homepage = "https://github.com/petereon/beaupy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
