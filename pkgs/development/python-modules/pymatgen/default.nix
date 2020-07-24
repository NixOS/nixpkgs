{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, plotly, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2020.4.29";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf9c89f2c742acf524f3a778cd269164abf582e87ab5f297cd83802fe00c309d";
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
    ruamel_yaml
    scipy
    six
    spglib
    sympy
    tabulate
  ];

  # No tests in pypi tarball.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
