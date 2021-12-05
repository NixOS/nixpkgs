{ lib, buildPythonPackage, fetchPypi, enum34, glibcLocales, matplotlib, monty
, networkx, numpy, palettable, pandas, plotly, pydispatcher, requests
, ruamel-yaml, scipy, six, spglib, sympy, tabulate, uncertainties }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2022.0.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fb4db7d547f062266a1a113d898fb0626ded5a1f9101ef79681e171b7e45fad0";
  };

  nativeBuildInputs = [ glibcLocales ];

  propagatedBuildInputs = [
    enum34
    matplotlib
    monty
    networkx
    numpy
    palettable
    pandas
    plotly
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
    description =
      "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
