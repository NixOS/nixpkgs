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
, pytest-cov
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "rdflib";
  version = "6.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-GkqfSyApOFKPIiIYXhgaRZuMawk7PRYmxGDhnRI+Rz0=";
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
    pytest-cov
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
    "test_infix_owl_example1"
    "test_context"
    "test_guess_format_for_parse"
    "rdflib.extras.infixowl"
  ] ++ lib.optionals stdenv.isDarwin [
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
