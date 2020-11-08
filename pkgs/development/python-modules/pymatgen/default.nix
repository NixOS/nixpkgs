{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, plotly, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2020.8.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "23e5885e15195b37ce4c16ef93f474f741cb98451fa8dd4c319ec121f4887256";
  };

  nativeBuildInputs = [ glibcLocales ];


  requiredPythonModules = [
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
