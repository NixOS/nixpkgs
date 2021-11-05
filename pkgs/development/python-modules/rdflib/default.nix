{ lib
, buildPythonPackage
, fetchPypi
, html5lib
, isodate
, networkx
, nose
, pyparsing
, tabulate
, pandas
, pytestCheckHook
, pythonOlder
, SPARQLWrapper
}:

buildPythonPackage rec {
  pname = "rdflib";
  version = "6.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-YTauBWABR07ir/X8W5VuYqEcOpxmuw89nAqqX7tWhU4=";
  };

  propagatedBuildInputs = [
    isodate
    html5lib
    pyparsing
    SPARQLWrapper
  ];

  checkInputs = [
    networkx
    pandas
    nose
    tabulate
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "api_key"
    "BerkeleyDBTestCase"
    "test_bad_password"
    "test_service"
    "testGuessFormatForParse"
  ];

  pythonImportsCheck = [
    "rdflib"
  ];

  meta = with lib; {
    description = "Python library for working with RDF";
    homepage = "https://rdflib.readthedocs.io";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
