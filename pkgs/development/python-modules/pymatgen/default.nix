{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, ase
, cython
, glibcLocales
, joblib
, matplotlib
, monty
, networkx
, numpy
, palettable
, pandas
, plotly
, pybtex
, pydispatcher
, pytestCheckHook
, pytest-xdist
, pythonOlder
, requests
, ruamel-yaml
, scipy
, seekpath
, spglib
, sympy
, tabulate
, uncertainties
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2024.2.23";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    rev= "v${version}";
    hash = "sha256-eswoup9ACj/PHVW3obcnZjD4tWemsmROZFtwGGigEYE=";
  };

  nativeBuildInputs = [
    cython
    glibcLocales
  ];

  propagatedBuildInputs = [
    matplotlib
    monty
    networkx
    numpy
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

  nativeCheckInputs = [
    pytestCheckHook
    pytest-xdist
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);
  preCheck = ''
    # hide from tests
    mv pymatgen _pymatgen
    # ensure tests can find these
    export PMG_TEST_FILES_DIR="$(realpath ./tests/files)"
    # some tests cover the command-line scripts
    export PATH=$out/bin:$PATH
  '';
  disabledTests = [
    # presumably won't work with our dir layouts
    "test_egg_sources_txt_is_complete"
    # borderline precision failure
    "test_thermal_conductivity"
  ];

  passthru.optional-dependencies = {
    ase = [ ase ];
    joblib = [ joblib ];
    seekpath = [ seekpath ];
  };

  pythonImportsCheck = [
    "pymatgen"
  ];

  meta = with lib; {
    broken = stdenv.isDarwin;  # tests segfault. that's bad.
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
