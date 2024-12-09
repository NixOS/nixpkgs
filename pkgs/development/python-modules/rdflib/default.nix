{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # builds
  poetry-core,

  # propagates
  isodate,
  pyparsing,

  # extras: networkx
  networkx,

  # extras: html
  html5lib,

  # tests
  pip,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rdflib";
  version = "7.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = "rdflib";
    rev = "refs/tags/${version}";
    hash = "sha256-/jRUV7H6JBWBv/gphjLjjifbEwMSxWke5STqkeSzwoE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    pyparsing
  ] ++ lib.optionals (pythonOlder "3.11") [ isodate ];

  optional-dependencies = {
    html = [ html5lib ];
    networkx = [ networkx ];
  };

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    pip
    pytest-cov-stub
    pytestCheckHook
    setuptools
  ] ++ optional-dependencies.networkx ++ optional-dependencies.html;

  pytestFlagsArray = [
    # requires network access
    "--deselect=rdflib/__init__.py::rdflib"
    "--deselect=test/jsonld/test_onedotone.py::test_suite"
  ];

  disabledTests =
    [
      # Requires network access
      "test_service"
      "testGuessFormatForParse"
      "test_infix_owl_example1"
      "test_context"
      "test_example"
      "test_guess_format_for_parse"
      "rdflib.extras.infixowl"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Require loopback network access
      "TestGraphHTTP"
    ];

  pythonImportsCheck = [ "rdflib" ];

  meta = with lib; {
    description = "Python library for working with RDF";
    homepage = "https://rdflib.readthedocs.io";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
