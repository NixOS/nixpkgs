{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  interface-meta,
  narwhals,
  numpy,
  pandas,
  scipy,
  typing-extensions,
  wrapt,
  pyarrow,
  polars,
  sympy,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "formulaic";
  version = "1.2.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "matthewwardrop";
    repo = "formulaic";
    tag = "v${version}";
    hash = "sha256-mZt+cwk/AaUmmeCj7aLu1QEBqlPUVUqQbYdgETMj/vY=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = version;

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    narwhals
    numpy
    pandas
    scipy
    wrapt
    typing-extensions
    interface-meta
  ];

  optional-dependencies = {
    arrow = [ pyarrow ];
    polars = [ polars ];
    calculus = [ sympy ];
  };

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ optional-dependencies.arrow
  ++ optional-dependencies.calculus;

  pythonImportsCheck = [ "formulaic" ];

  meta = with lib; {
    description = "High-performance implementation of Wilkinson formulas";
    homepage = "https://matthewwardrop.github.io/formulaic/";
    changelog = "https://github.com/matthewwardrop/formulaic/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ swflint ];
  };
}
