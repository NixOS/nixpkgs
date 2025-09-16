{
  lib,
  allpairspy,
  approval-utilities,
  beautifulsoup4,
  buildPythonPackage,
  empty-files,
  fetchFromGitHub,
  mock,
  numpy,
  pyperclip,
  pytest,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  testfixtures,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "approvaltests";
  version = "15.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    tag = "v${version}";
    hash = "sha256-lXc81hQzxHxpg96OSWkkWmdmLOf4nU56dIKYVgLo+s8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    allpairspy
    approval-utilities
    beautifulsoup4
    empty-files
    mock
    pyperclip
    pytest
    testfixtures
    typing-extensions
  ];

  nativeCheckInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    "test_warnings"
    # test runs another python interpreter, ignoring $PYTHONPATH
    "test_command_line_verify"
  ];

  pythonImportsCheck = [
    "approvaltests.approvals"
    "approvaltests.reporters.generic_diff_reporter_factory"
  ];

  meta = {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    changelog = "https://github.com/approvals/ApprovalTests.Python/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
