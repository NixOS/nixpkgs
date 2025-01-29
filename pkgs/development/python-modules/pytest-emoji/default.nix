{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-emoji";
  version = "0.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hackebrot";
    repo = "pytest-emoji";
    tag = version;
    hash = "sha256-GuKBbIIODDnMi9YMX3zR4Jc3cbK+Zibj1ZeWvYkUY24=";
  };

  buildInputs = [ pytest ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pytest_emoji" ];

  disabledTests = [
    # Test scompare CLI output
    "test_emoji_disabled_by_default_verbose"
    "test_emoji_enabled_verbose"
    "test_emoji_enabled_custom_verbose"
  ];

  meta = with lib; {
    description = "Pytest plugin that adds emojis to test result report";
    homepage = "https://github.com/hackebrot/pytest-emoji";
    changelog = "https://github.com/hackebrot/pytest-emoji/releases/tag/0.2.0";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
