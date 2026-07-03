{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "dpcontracts";
  version = "0.6.0-unstable-2018-11-20";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = "contracts";
    rev = "45cb8542272c2ebe095c6efb97aa9407ddc8bf3c";
    hash = "sha256-FygJPXo7lZ9tlfqY6KmPJ3PLIilMGLBr3013uj9hCEs=";
  };

  # Replacements in README.rst are necessary to check it with doctest
  postPatch = ''
    substituteInPlace README.rst \
      --replace-fail " PreconditionError" " dpcontracts.PreconditionError" \
      --replace-fail " PostconditionError" " dpcontracts.PostconditionError" \
      --replace-fail ">>> class Counter:" $'>>> from dpcontracts import preserve\n    >>> class Counter:'
  '';

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  enabledTestPaths = [
    "README.rst"
  ];

  pythonImportsCheck = [ "dpcontracts" ];

  meta = {
    description = "Provides a collection of decorators that makes it easy to write software using contracts";
    homepage = "https://github.com/deadpixi/contracts";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ gador ];
  };
}
