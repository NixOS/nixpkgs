{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, plotly, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2020.11.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2c51c2c8862ea0d59346114f43be9e65ea134ed5b2bbd8dae766c4f6b02f5e3c";
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
