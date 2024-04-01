{ lib
, allpairspy
, approval-utilities
, beautifulsoup4
, buildPythonPackage
, empty-files
, fetchFromGitHub
, fetchpatch2
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
  version = "11.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    rev = "refs/tags/v${version}";
    hash = "sha256-VqE2Oj3b+ZfKT+fhJ9DxBClfa8Wz8w/puAnAotN3eG4=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/approvals/ApprovalTests.Python/commit/dac7c8a8aa62f31dca7a687d4dbf08158351d5e1.patch";
      hash = "sha256-TMyfXNtzpGci6tdFRhxiKJRjCWRD5LkaffPY8EVj53E=";
    })
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
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
    # Tests expect paths below ApprovalTests.Python directory
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
