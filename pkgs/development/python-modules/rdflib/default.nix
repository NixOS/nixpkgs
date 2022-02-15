{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
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
  version = "6.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = version;
    hash = "sha256:1ih7vx4i16np1p8ig5faw74apmbm7kgyj9alya521yvzid6d7pzd";
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

  pytestFlagsArray = [
    # requires network access
    "--deselect rdflib/__init__.py::rdflib"
    "--deselect test/jsonld/test_onedotone.py::test_suite"
  ];

  disabledTests = [
    # Requires network access
    "api_key"
    "BerkeleyDBTestCase"
    "test_bad_password"
    "test_service"
    "testGuessFormatForParse"
  ] ++ lib.optional stdenv.isDarwin [
    # Require loopback network access
    "test_sparqlstore"
    "test_sparqlupdatestore_mock"
    "TestGraphHTTP"
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
