{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, cdcs
, bibtexparser
, habanero
, pandas
, requests
, numpy
, matplotlib
, unidecode
, datamodeldict
, xmltodict
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  version = "0.3.1";
  pname = "potentials";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02l1rav5jdfsb00byxbswyhqdnjljp9y7g4ddn4mivzi7x39qa52";
  };

  propagatedBuildInputs = [
    ipywidgets
    cdcs
    bibtexparser
    habanero
    pandas
    requests
    numpy
    matplotlib
    unidecode
    datamodeldict
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
