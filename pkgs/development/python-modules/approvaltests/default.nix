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
<<<<<<< HEAD
  version = "16.2.1";
=======
  version = "15.3.2";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "approvals";
    repo = "ApprovalTests.Python";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-gu9Wa52yekUmFg1zlVtLSN18hUuqVOUCN7krUh0m1m0=";
  };

  postPatch = ''
    test -f setup.py || mv setup/setup.py .
    touch setup/__init__.py
    substituteInPlace setup.py \
      --replace-fail "from setup_utils" "from setup.setup_utils"

    patchShebangs internal_documentation/scripts
=======
    hash = "sha256-cOaL8u5q9kx+yLB0e/ALnGYYGF5v50wsIIF1UUTPe1Y=";
  };

  postPatch = ''
    echo 'version_number = "${version}"' > version.py
    mv .github approvaltests approval_utilities tests setup
    cd setup
    rm setup.cfg
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
