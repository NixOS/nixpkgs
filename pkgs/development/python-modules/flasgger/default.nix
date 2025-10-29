{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,

  # build-system
  setuptools,

  # dependencies
  flask,
  jsonschema,
  mistune,
  packaging,
  pyyaml,
  six,
  werkzeug,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "flasgger";
  version = "0.9.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "flasgger";
    repo = "flasgger";
    rev = "v${version}";
    hash = "sha256-ULEf9DJiz/S2wKlb/vjGto8VCI0QDcm0pkU5rlOwtiE=";
  };

  patches = [
    # https://github.com/flasgger/flasgger/pull/633
    (fetchpatch {
      name = "fix-tests-with-click-8.2.patch";
      url = "https://github.com/flasgger/flasgger/commit/08591b60e988c0002fcf1b1e9f98b78e041d2732.patch";
      hash = "sha256-DHaaY9W+cta3M2VA8S+ZQWacmgSpeyP03SKTiIlfBRM=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    flask
    jsonschema
    mistune
    packaging
    pyyaml
    six
    werkzeug
  ];

  pythonImportsCheck = [ "flasgger" ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "tests"
  ];

  disabledTestPaths = [
    # missing flex dependency
    "tests/test_examples.py"
  ];

  meta = with lib; {
    description = "Easy OpenAPI specs and Swagger UI for your Flask API";
    homepage = "https://github.com/flasgger/flasgger/";
    license = licenses.mit;
    maintainers = [ ];
  };
}
