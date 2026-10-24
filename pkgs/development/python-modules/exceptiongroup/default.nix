{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-scm,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "exceptiongroup";
  version = "1.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agronholm";
    repo = "exceptiongroup";
    # 1.3.1 plus unreleased fixes including:
    # - https://github.com/agronholm/exceptiongroup/pull/162
    # - https://github.com/agronholm/exceptiongroup/pull/155
    rev = "0cc03ebe0b9490092723deabbc012e7be8ca1192";
    hash = "sha256-rR/4C6LkQtzuPskx7aJxi0NutZT4/nbELI5KQ/En7QA=";
  };

  build-system = [ flit-scm ];

  dependencies = lib.optionals (pythonOlder "3.13") [ typing-extensions ];

  nativeCheckInputs = [ pytestCheckHook ];

  doCheck = pythonAtLeast "3.11"; # infinite recursion with pytest

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # RecursionError not raised
    "test_deep_split"
    "test_deep_subgroup"
  ];

  pythonImportsCheck = [ "exceptiongroup" ];

  meta = {
    description = "Backport of PEP 654 (exception groups)";
    homepage = "https://github.com/agronholm/exceptiongroup";
    changelog = "https://github.com/agronholm/exceptiongroup/blob/${version}/CHANGES.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
