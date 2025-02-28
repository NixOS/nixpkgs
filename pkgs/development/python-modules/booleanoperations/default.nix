{
  lib,
  buildPythonPackage,
  fetchPypi,
  fonttools,
  pyclipper,
  defcon,
  fontpens,
  setuptools,
  setuptools-scm,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "booleanoperations";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "booleanOperations";
    inherit version;
    hash = "sha256-jPqCHDKtN0+hINay4LRE6+rFfJHmYxUoZF+hmsKigbg=";
    extension = "zip";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fonttools
    pyclipper
  ];

  pythonImportsCheck = [ "booleanOperations" ];

  nativeCheckInputs = [
    defcon
    fontpens
    pytestCheckHook
  ];

  meta = {
    description = "Boolean operations on paths";
    homepage = "https://github.com/typemytype/booleanOperations";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
}
