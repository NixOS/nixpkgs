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
, yabadaba
}:

buildPythonPackage rec {
  version = "0.3.7";
  pname = "potentials";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vkrNVRf9ntYSpf8nXmAmGjc+sQ4iFllisYHd9s+uQv0=";
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
    yabadaba
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
