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
  version = "2022.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "901d00105142c9added48275188e289e91b3098251ec107aef90acaef3ea6d0d";
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
