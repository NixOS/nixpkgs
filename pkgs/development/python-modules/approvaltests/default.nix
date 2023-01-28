{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# propagates
, allpairspy
, beautifulsoup4
, empty-files
, pyperclip
, pytest

# tests
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  version = "5.4.2";
  pname = "approvaltests";
  format = "setuptools";

  disabled = pythonOlder "3.6.1";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-ZXtIM3McpfDFCaedlbJ6SU+Er5NyfI8kGnrn7sb1V5M=";
  };

  propagatedBuildInputs = [
    allpairspy
    beautifulsoup4
    empty-files
    pyperclip
    pytest
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
