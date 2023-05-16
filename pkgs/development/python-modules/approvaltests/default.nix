{ lib
<<<<<<< HEAD
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
, pytestCheckHook
, pythonOlder
, testfixtures
, typing-extensions
}:

buildPythonPackage rec {
  pname = "approvaltests";
  version = "9.0.0";
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

<<<<<<< HEAD
=======
  # no tests included in PyPI tarball
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
<<<<<<< HEAD
    hash = "sha256-tyUPXeMdFuzlBY/HrGHLDEwYngzBELayaVVfEh92lbE=";
=======
    hash = "sha256-guZR996UBqWsBnZx2kdSffkPzkMRfS48b1XcM5L8+I4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    allpairspy
    approval-utilities
    beautifulsoup4
    empty-files
    mrjob
    pyperclip
    pytest
<<<<<<< HEAD
    testfixtures
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    typing-extensions
  ];

  nativeCheckInputs = [
<<<<<<< HEAD
    mock
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    numpy
    pytestCheckHook
  ];

  disabledTests = [
<<<<<<< HEAD
    # Tests expects paths below ApprovalTests.Python directory
=======
    # tests expects paths below ApprovalTests.Python directory
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/approvals/ApprovalTests.Python/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
=======
    license = licenses.asl20;
    maintainers = [ maintainers.marsam ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
