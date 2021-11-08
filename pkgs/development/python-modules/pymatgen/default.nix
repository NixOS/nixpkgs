{ lib, buildPythonPackage, fetchPypi
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
  version = "2022.0.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03d24ebafc21becab376c26de09437dd5cfb7bda7099046194e95b4c9fa35209";
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
  pythonImportsCheck = [ "pymatgen" ];

  meta = with lib; {
    description = "A robust materials analysis code that defines core object representations for structures and molecules";
    homepage = "https://pymatgen.org/";
    license = licenses.mit;
    maintainers = with maintainers; [ psyanticy ];
  };
}
