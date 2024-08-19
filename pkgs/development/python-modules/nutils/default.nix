{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  appdirs,
  bottombar,
  numpy,
  nutils-poly,
  psutil,
  stringly,
  treelog,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "nutils";
  version = "8.8";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "evalf";
    repo = "nutils";
    rev = "refs/tags/v${version}";
    hash = "sha256-E/y1YXW+0+LfntRQsdIU9rMOmN8mlFwXktD/sViJo3I=";
  };

  build-system = [ flit-core ];

  dependencies = [
    appdirs
    bottombar
    numpy
    nutils-poly
    psutil
    stringly
    treelog
  ];

  pythonRelaxDeps = [ "psutil" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "nutils" ];

  disabledTestPaths = [
    # AttributeError: type object 'setup' has no attribute '__code__'
    "tests/test_cli.py"
  ];

  meta = with lib; {
    description = "Numerical Utilities for Finite Element Analysis";
    changelog = "https://github.com/evalf/nutils/releases/tag/v${version}";
    homepage = "https://www.nutils.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ Scriptkiddi ];
  };
}
