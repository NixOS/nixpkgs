{
  lib,
  astor,
  buildPythonPackage,
  fetchFromGitHub,
  git,
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
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "formulaic";
    rev = "refs/tags/v${version}";
    hash = "sha256-qivWv1LtFkW55tVKD/Zjd8Q5gVbxhDpZ0inkV6NR7bA=";
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
