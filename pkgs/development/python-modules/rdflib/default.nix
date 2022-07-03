{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# propagates
, isodate
, pyparsing

# propagates <3.8
, importlib-metadata

# extras: networkx
, networkx

# extras: html
, html5lib

# tests
, pytestCheckHook
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
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
    html = [
      html5lib
    ];
    networkx = [
      networkx
    ];
  };

  checkInputs = [
    pytestCheckHook
  ]
  ++ passthru.optional-dependencies.networkx
  ++ passthru.optional-dependencies.html;

  pytestFlagsArray = [
    # requires network access
    "--deselect=rdflib/__init__.py::rdflib"
    "--deselect=test/jsonld/test_onedotone.py::test_suite"
  ];

  disabledTests = [
    # Requires network access
    "test_service"
    "testGuessFormatForParse"
  ] ++ lib.optional stdenv.isDarwin [
    # Require loopback network access
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
