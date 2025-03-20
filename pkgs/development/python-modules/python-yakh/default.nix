{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # nativeCheckInputs
  pytestCheckHook,
}:

buildPythonPackage rec {
  # NOTE that this is not https://pypi.org/project/yakh/
  pname = "python-yakh";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "petereon";
    repo = "yakh";
    rev = "v${version}";
    hash = "sha256-mXG0fit+0MLOkn2ezRzLboDGKxkES/T7kyWAfaF0EQQ=";
  };

  build-system = [
    poetry-core
  ];

  pythonImportsCheck = [
    "yakh"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Yet Another Keypress Handler";
    homepage = "https://pypi.org/project/python-yakh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ doronbehar ];
  };
}
