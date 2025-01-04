{
  astor,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  pytestCheckHook,
  pythonOlder,
  tomli,
}:

buildPythonPackage rec {
  pname = "flynt";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ikamensh";
    repo = "flynt";
    tag = version;
    hash = "sha256-UHY4UDBHcP3ARikktIehSUD3Dx8A0xpOnfKWWrLCsOY=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [ astor ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "flynt" ];

  disabledTests = [
    # AssertionError
    "test_fstringify"
    "test_mixed_quote_types_unsafe"
  ];

  meta = with lib; {
    description = "Tool to automatically convert old string literal formatting to f-strings";
    homepage = "https://github.com/ikamensh/flynt";
    changelog = "https://github.com/ikamensh/flynt/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ cpcloud ];
    mainProgram = "flynt";
  };
}
