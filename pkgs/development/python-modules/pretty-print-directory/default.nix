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
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mmcdermott";
    repo = "pretty-print-directory";
    tag = version;
    hash = "sha256-nX6xc9CaVur3zpaYLNXr+s34zFnYVU/ptIgucfo8nQQ=";
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
