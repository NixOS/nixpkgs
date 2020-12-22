{ stdenv, buildPythonPackage, fetchPypi
, enum34
, glibcLocales
, matplotlib
, monty
, networkx
, numpy
, palettable
, pandas
, plotly
, pydispatcher
, requests
, ruamel_yaml
, scipy
, six
, spglib
, sympy
, tabulate
, uncertainties
}:

buildPythonPackage rec {
  pname = "pymatgen";
  version = "2020.12.18";

  src = fetchPypi {
    inherit pname version;
    sha256 = "77429b24fb05b31ccec15e133ebfe579c4e27824eccc8fe725610e971df3b4d9";
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
    uncertainties
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
