{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "pretty-print-directory";
  version = "0.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmcdermott";
    repo = "pretty-print-directory";
    tag = version;
    hash = "sha256-zjkKLx/zWQvW1ncwQAkOygIZIMicfLPDwHEEX4uIbSg=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pytestFlagsArray = [ "tests" ];

  pythonImportsCheck = [
    "pretty_print_directory"
  ];

  meta = {
    description = "Simple utility to pretty-print the contents of a directory";
    homepage = "https://github.com/mmcdermott/pretty-print-directory";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
