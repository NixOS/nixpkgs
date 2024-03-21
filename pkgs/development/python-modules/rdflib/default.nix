{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder

# builds
, poetry-core

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
, pip
, pytest-cov
, pytestCheckHook
, pytest_7
, setuptools
}:

buildPythonPackage rec {
  pname = "rdflib";
  version = "7.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-VCjvgXMun1Hs+gPeqjzLXbIX1NBQ5aMLz0aWlwsm0iY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

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

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pip
    pytest-cov
    # Failed: DID NOT WARN. No warnings of type (<class 'UserWarning'>,) were emitted.
    (pytestCheckHook.override { pytest = pytest_7; })
    setuptools
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
    "test_example"
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
