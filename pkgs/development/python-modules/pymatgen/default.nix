{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, numpy, pydispatcher, sympy, requests, monty, ruamel_yaml, six, scipy, tabulate, enum34, matplotlib, palettable, spglib, pandas, networkx }:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2018.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "dee5dbd8008081de9f27759c20c550d09a07136eeebfe941e3d05fd88ccace18";
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
