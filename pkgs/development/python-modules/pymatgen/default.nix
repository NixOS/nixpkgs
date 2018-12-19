{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2018.10.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf9e030abafc4cd7c33847acf4bf0677bfc707f68fed48469c672d1980a8ceb9";
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
