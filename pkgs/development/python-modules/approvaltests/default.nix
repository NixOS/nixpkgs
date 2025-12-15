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
  pyyaml,
  setuptools,
  testfixtures,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "approvaltests";
  version = "16.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    tag = "v${version}";
    hash = "sha256-SAevC6yIDndtNRakyzsRNw4vM2wLc/Qbs3ZlmXEa+40=";
  };

  postPatch = ''
    test -f setup.py || mv setup/setup.py .
    touch setup/__init__.py
    substituteInPlace setup.py \
      --replace-fail "from setup_utils" "from setup.setup_utils"

    patchShebangs internal_documentation/scripts
  '';

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
    pyyaml
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
