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
  version = "3.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "beaupy";
    rev = "v${version}";
    hash = "sha256-9iJZFOtQ6UTc8i4cN4soEG0SLcljenAQwq0wfK6r/Rw=";
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
