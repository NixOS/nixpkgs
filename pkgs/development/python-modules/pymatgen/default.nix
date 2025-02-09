{ lib
, buildPythonPackage
, fetchFromGitHub
, cython
, glibcLocales
, matplotlib
, monty
, networkx
, numpy
, palettable
, pandas
, plotly
, pybtex
, pydispatcher
, pythonOlder
, requests
, ruamel-yaml
, scipy
, spglib
, sympy
, tabulate
, uncertainties
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2022.3.29";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    rev= "v${version}";
    hash = "sha256-B2piRWx9TfKlGTPOAAGsq2GxyfHIRBVFpk6dxES0WF0=";
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

  # Tests are not detected by pytest
  doCheck = false;

  pythonImportsCheck = [
    "pymatgen"
  ];

  meta = with lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
