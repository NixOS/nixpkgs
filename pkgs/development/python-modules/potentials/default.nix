{ lib
, bibtexparser
, buildPythonPackage
, cdcs
, datamodeldict
, fetchPypi
, habanero
, ipywidgets
, lxml
, matplotlib
, numpy
, pandas
, pytestCheckHook
, pythonOlder
, requests
, scipy
, unidecode
, xmltodict
}:

buildPythonPackage rec {
  version = "0.3.2";
  pname = "potentials";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-u++ClAAc96u7k8w756sFR4oCtIOgERQ7foklxWWPprY=";
  };

  propagatedBuildInputs = [
    bibtexparser
    cdcs
    datamodeldict
    habanero
    ipywidgets
    lxml
    matplotlib
    numpy
    pandas
    requests
    scipy
    unidecode
    xmltodict
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "potentials"
  ];

  meta = with lib; {
    description = "Python API database tools for accessing the NIST Interatomic Potentials Repository";
    homepage = "https://github.com/usnistgov/potentials";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
