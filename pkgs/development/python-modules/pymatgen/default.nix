{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2018.8.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9bb3b170ca8654c956fa2efdd31107570c0610f7585d90e4a541eb99cee41603";
  };

  nativeBuildInputs = [ glibcLocales ];
  propagatedBuildInputs = [ numpy pydispatcher sympy requests monty ruamel_yaml six scipy tabulate enum34 matplotlib palettable spglib pandas ];
  
  # No tests in pypi tarball.
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = http://pymatgen.org/;
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}

