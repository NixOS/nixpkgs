{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# propagates
, allpairspy
, approval-utilities
, beautifulsoup4
, empty-files
, mrjob
, pyperclip
, pytest
, typing-extensions

# tests
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "8.2.5";
  pname = "approvaltests";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-guZR996UBqWsBnZx2kdSffkPzkMRfS48b1XcM5L8+I4=";
  };

  propagatedBuildInputs = [
    allpairspy
    approval-utilities
    beautifulsoup4
    empty-files
    mrjob
    pyperclip
    pytest
    typing-extensions
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  disabledTests = [
    # tests expects paths below ApprovalTests.Python directory
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
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
  };
}
