{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  libcst,
  mypy-extensions,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "monkeytype";
  version = "23.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Instagram";
    repo = "MonkeyType";
    rev = "refs/tags/v${version}";
    hash = "sha256-DQ/3go53+0PQkhZcL2dX8MI/z4Iq7kTYd5EbacMNxT4=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    libcst
    mypy-extensions
  ];

  pythonImportsCheck = [
    "monkeytype"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # Disable broken tests
    "test_excludes_site_packages"
    "test_callee_throws_recovers"
    "test_nested_callee_throws_recovers"
    "test_caller_handles_callee_exception"
    "test_generator_trace"
    "test_return_none"
    "test_access_property"
  ];

  meta = {
    description = "Python library that generates static type annotations by collecting runtime types";
    homepage = "https://github.com/Instagram/MonkeyType/";
    changelog = "https://github.com/Instagram/MonkeyType/blob/${src.rev}/CHANGES.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ drupol ];
  };
}
