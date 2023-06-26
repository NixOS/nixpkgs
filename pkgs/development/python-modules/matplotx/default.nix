{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, setuptools
, matplotlib
, numpy
, networkx
, pypng
, scipy
}:

buildPythonPackage rec {
  pname = "matplotx";
  version = "0.3.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "nschloe";
    repo = "matplotx";
    rev = "v${version}";
    hash = "sha256-EWEiEY23uFwd/vgWVLCH/buUmgRqz1rqqlJEdXINYMg=";
  };

  propagatedBuildInputs = [
    setuptools
    matplotlib
    numpy
  ];

  passthru.optional-dependencies = {
    all = [
      networkx
      pypng
      scipy
    ];
    contour = [ networkx ];
    spy = [
      pypng
      scipy
    ];
  };

  checkInputs = passthru.optional-dependencies.all;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    "tests/test_spy.py" # Requires meshzoo (non-free) and pytest-codeblocks (not packaged)
  ];

  pythonImportsCheck = [ "matplotx" ];

  meta = {
    homepage = "https://github.com/nschloe/matplotx";
    description = "More styles and useful extensions for Matplotlib";
    changelog = "https://github.com/nschloe/matplotx/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ swflint ];
  };
}

