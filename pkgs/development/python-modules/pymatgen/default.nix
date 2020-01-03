{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2019.10.16";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a8e8b169001737cdf16bb89b26c391963ba2bead54ea510530a52586e2072234";
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
