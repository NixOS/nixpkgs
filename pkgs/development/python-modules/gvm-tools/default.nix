{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  python-gvm,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "gvm-tools";
  version = "24.3.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-tools";
    rev = "refs/tags/v${version}";
    hash = "sha256-LLXMdT1q6IWsbsRjflpGN5pcjUCXWzdFK3gMw4mBm0U=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ python-gvm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
  ] ++ lib.optionals (pythonAtLeast "3.10") [ "HelpFormattingParserTestCase" ];

  pythonImportsCheck = [ "gvmtools" ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
