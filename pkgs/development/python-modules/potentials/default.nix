{
  lib,
  bibtexparser,
  buildPythonPackage,
  cdcs,
  datamodeldict,
  fetchPypi,
  habanero,
  ipywidgets,
  lxml,
  matplotlib,
  numpy,
  pandas,
  pythonOlder,
  requests,
  scipy,
  setuptools,
  unidecode,
  xmltodict,
  yabadaba,
}:

buildPythonPackage rec {
  pname = "potentials";
  version = "0.3.8";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZXsqsqsgWntZUOuW1/2KAhsbnienHu6VFctxYkw+GCU=";
  };

  build-system = [ setuptools ];

  dependencies = [
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

  pythonImportsCheck = [ "potentials" ];

  meta = with lib; {
    description = "Python API database tools for accessing the NIST Interatomic Potentials Repository";
    homepage = "https://github.com/usnistgov/potentials";
    changelog = "https://github.com/usnistgov/potentials/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
