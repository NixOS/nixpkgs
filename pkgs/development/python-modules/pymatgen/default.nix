{
  lib,
  ase,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  glibcLocales,
  joblib,
  matplotlib,
  monty,
  networkx,
  oldest-supported-numpy,
  palettable,
  pandas,
  plotly,
  pybtex,
  pydispatcher,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  requests,
  ruamel-yaml,
  scipy,
  seekpath,
  setuptools,
  spglib,
  sympy,
  tabulate,
  uncertainties,
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2024.9.17.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    rev = "refs/tags/v${version}";
    hash = "sha256-o76bGItldcLfgZ5KDw2uL0GJvyljQJEwISR0topVR44=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cython
    glibcLocales
  ];

  dependencies = [
    matplotlib
    monty
    networkx
    oldest-supported-numpy
    palettable
    pandas
    plotly
    pybtex
    pydispatcher
    requests
    ruamel-yaml
    scipy
    spglib
    sympy
    tabulate
    uncertainties
  ];

  optional-dependencies = {
    ase = [ ase ];
    joblib = [ joblib ];
    seekpath = [ seekpath ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    # ensure tests can find these
    export PMG_TEST_FILES_DIR="$(realpath ./tests/files)"
    # some tests cover the command-line scripts
    export PATH=$out/bin:$PATH
  '';

  pythonImportsCheck = [ "pymatgen" ];

  meta = with lib; {
    description = "Robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    changelog = "https://github.com/materialsproject/pymatgen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
