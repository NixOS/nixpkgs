{ lib, buildPythonPackage, fetchFromGitHub
, cython
, enum34
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
, requests
, ruamel-yaml
, scipy
, six
, spglib
, sympy
, tabulate
, uncertainties
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2022.2.7";

  # sdist doesn't include c files
  src = fetchFromGitHub {
    owner = "materialsproject";
    repo = "pymatgen";
    rev= "v${version}";
    sha256 = "sha256-92Dxmo1Z9LR2caSOftIf1I6jeZmqDe3SqhhoCofWraw=";
  };

  nativeBuildInputs = [
    cython
    glibcLocales
  ];

  propagatedBuildInputs = [
    enum34
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
    six
    spglib
    sympy
    tabulate
    uncertainties
  ];

  # No tests in pypi tarball.
  doCheck = false;
  pythonImportsCheck = [ "pymatgen" ];

  meta = with lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
