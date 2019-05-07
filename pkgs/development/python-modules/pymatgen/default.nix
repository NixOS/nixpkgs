{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2019.2.28";

  src = fetchPypi {
    inherit pname version;
    sha256 = "fe4c9b8b16d618fa531a09073d69db6ab02c0c379e672862a41163e39ac91e85";
  };

  nativeBuildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ numpy pydispatcher sympy requests monty ruamel_yaml six scipy tabulate enum34 matplotlib palettable spglib pandas networkx ];

  # No tests in pypi tarball.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = http://pymatgen.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
