{ lib
, allpairspy
, approval-utilities
, beautifulsoup4
, buildPythonPackage
, empty-files
, fetchFromGitHub
, mock
, mrjob
, numpy
, pyperclip
, pytest
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, setuptools
, testfixtures
, typing-extensions
}:

buildPythonPackage rec {
  pname = "approvaltests";
  version = "11.1.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-VM4TP98bS9NmhxZz+YHMJrHKr5g6E6aYidxjKQyXp7k=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    allpairspy
    approval-utilities
    beautifulsoup4
    empty-files
    mock
    mrjob
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
    # Tests expects paths below ApprovalTests.Python directory
    "test_received_filename"
    "test_pytest_namer"
  ];

  pythonImportsCheck = [
    "approvaltests.approvals"
    "approvaltests.reporters.generic_diff_reporter_factory"
  ];

  meta = with lib; {
    description = "Assertion/verification library to aid testing";
    homepage = "https://github.com/approvals/ApprovalTests.Python";
    changelog = "https://github.com/approvals/ApprovalTests.Python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
