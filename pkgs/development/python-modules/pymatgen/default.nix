{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, plotly, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2020.9.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e00268a5f172db881d10d70831a882d9b045ae05ceea78c977e1031b89688f07";
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
