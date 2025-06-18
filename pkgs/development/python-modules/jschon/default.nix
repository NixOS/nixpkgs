{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  wheel,
  rfc3986,
  pytestCheckHook,
  hypothesis,
  requests,
  pytest-httpserver,
  pytest-xdist,
}:

buildPythonPackage rec {
  pname = "jschon";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marksparkza";
    repo = "jschon";
    rev = "v${version}";
    hash = "sha256-uOvEIEUEILsoLuV5U9AJCQAlT4iHQhsnSt65gfCiW0k=";
    fetchSubmodules = true;
  };

  build-system = [
    setuptools
    wheel
  ];

  dependencies = [
    rfc3986
  ];

  pythonImportsCheck = [
    "jschon"
    "jschon.catalog"
    "jschon.vocabulary"
    "jschon.exc"
    "jschon.exceptions"
    "jschon.formats"
    "jschon.json"
    "jschon.jsonpatch"
    "jschon.jsonpointer"
    "jschon.jsonschema"
    "jschon.output"
    "jschon.uri"
    "jschon.utils"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    requests
    pytest-httpserver
    #pytest-benchmark # not needed for distribution
    pytest-xdist # not used upstream, but massive speedup
  ];

  disabledTests = [
    # flaky, timing sensitive
    "test_keyword_dependency_resolution"
  ];

  disabledTestPaths = [
    "tests/test_benchmarks.py"
  ];

  # used in checks
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "An object-oriented JSON Schema implementation for Python";
    homepage = "https://github.com/marksparkza/jschon";
    changelog = "https://github.com/marksparkza/jschon/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
