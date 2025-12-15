{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  pytestCheckHook,
  pythonAtLeast,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "beartype";
  version = "0.21.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beartype";
    repo = "beartype";
    tag = "v${version}";
    hash = "sha256-oD7LS+c+mZ8W4YnAaAYxQkbUlmO8E2TPxy0PBI7Jr7A=";
  };

  build-system = [ hatchling ];

  nativeCheckInputs = [
    pytestCheckHook
    typing-extensions
  ];

  pythonImportsCheck = [ "beartype" ];

  disabledTests = [
    # No warnings of type (<class 'beartype.roar._roarwarn.BeartypeValeLambdaWarning'>,) were emitted.
    "test_is_hint_pep593_beartype"
  ]
  ++ lib.optionals (pythonAtLeast "3.13") [
    # this test is not run upstream, and broke in 3.13 (_nparams removed)
    "test_door_is_subhint"
  ];

  meta = {
    description = "Fast runtime type checking for Python";
    homepage = "https://github.com/beartype/beartype";
    changelog = "https://github.com/beartype/beartype/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
