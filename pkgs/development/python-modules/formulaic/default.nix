{
  lib,
  astor,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  interface-meta,
  numpy,
  pandas,
  pytestCheckHook,
  pythonOlder,
  scipy,
  sympy,
  typing-extensions,
  wrapt,
}:

buildPythonPackage rec {
  pname = "formulaic";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "formulaic";
    rev = "refs/tags/v${version}";
    hash = "sha256-1Ygu4o6RXXTnvve8XZi+QMhCjvUyMspYWTyUH3p6+dg=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
    astor
    numpy
    pandas
    scipy
    wrapt
    typing-extensions
    interface-meta
    sympy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "formulaic" ];

  disabledTestPaths = [ "tests/transforms/test_poly.py" ];

  meta = with lib; {
    description = "High-performance implementation of Wilkinson formulas";
    homepage = "https://matthewwardrop.github.io/formulaic/";
    changelog = "https://github.com/matthewwardrop/formulaic/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ swflint ];
  };
}
