{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  fetchpatch,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "7.5.0";
  pyproject = true;

=======
  version = "7.2.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  src = fetchFromGitHub {
    owner = "RDFLib";
    repo = "rdflib";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-jZ5mbTz/ra/ZHAFyMmtqaM4RZw851gfTCBCRuPcGeYA=";
  };
=======
    hash = "sha256-FisMiBTiL6emJS0d7UmlwGUzayA+CME5GGWgw/owfhc=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/RDFLib/rdflib/commit/0ab817f86b5733c9a3b4ede7ef065b8d79e53fc5.diff";
      hash = "sha256-+yWzQ3MyH0wihgiQRMMXV/FpG8WlXaIBhpsDF4e3rbY=";
    })
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  build-system = [ poetry-core ];

  dependencies = [
    pyparsing
  ]
  ++ lib.optionals (pythonOlder "3.11") [ isodate ];

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
  ]
  ++ optional-dependencies.networkx
  ++ optional-dependencies.html;

  disabledTestPaths = [
    # requires network access
    "rdflib/__init__.py::rdflib"
    "test/jsonld/test_onedotone.py::test_suite"
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Require loopback network access
    "TestGraphHTTP"
  ];

  pythonImportsCheck = [ "rdflib" ];

<<<<<<< HEAD
  meta = {
    changelog = "https://github.com/RDFLib/rdflib/blob/${src.tag}/CHANGELOG.md";
    description = "Python library for working with RDF";
    homepage = "https://rdflib.readthedocs.io";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Python library for working with RDF";
    homepage = "https://rdflib.readthedocs.io";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
