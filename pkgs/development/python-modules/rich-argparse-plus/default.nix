{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, rich
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "rich-argparse-plus";
  version = "0.3.1.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "michelcrypt4d4mus";
    repo = "rich-argparse-plus";
    rev = "v${version}";
    hash = "sha256-oF2wuvyLYwObVJ4fhJl9b/sdfmQ2ahgKkfd9ZwObfPw=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    rich
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "rich_argparse_plus"
  ];

  disabledTests = [
    # Tests are comparing CLI output
    "test_spans"
    "test_actions_spans_in_usage"
    "test_boolean_optional_action_spans"
    "test_usage_spans_errors"
    "test_text_highlighter"
    "test_default_highlights"
  ];

  meta = with lib; {
    description = "Library to help formatting argparse";
    homepage = "https://github.com/michelcrypt4d4mus/rich-argparse-plus";
    changelog = "https://github.com/michelcrypt4d4mus/rich-argparse-plus/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
