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
}:

buildPythonPackage rec {
  pname = "approvaltests";
  version = "10.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-2NaqqgrHXJovoVExvbr0s86eRbcxy+DUrsdRH/vak3E=";
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
  ];

  nativeCheckInputs = [
    numpy
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTests = [
    "test_docstrings"
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
