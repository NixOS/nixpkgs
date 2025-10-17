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
  version = "25.4.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "greenbone";
    repo = "gvm-tools";
    tag = "v${version}";
    hash = "sha256-BYkpHUSw9MU9SpJiQf1ZgG1ZCfRxyAyX/K+53wgnKoQ=";
  };

  __darwinAllowLocalNetworking = true;

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ python-gvm ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Don't test sending
    "SendTargetTestCase"
  ]
  ++ lib.optionals (pythonAtLeast "3.10") [ "HelpFormattingParserTestCase" ];

  pythonImportsCheck = [ "gvmtools" ];

  meta = with lib; {
    description = "Collection of APIs that help with remote controlling a Greenbone Security Manager";
    homepage = "https://github.com/greenbone/gvm-tools";
    changelog = "https://github.com/greenbone/gvm-tools/releases/tag/${src.tag}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
