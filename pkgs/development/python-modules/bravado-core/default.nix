{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
  # build inputs
, jsonref
, jsonschema
, python-dateutil
, pyyaml
, requests
, simplejson
, six
, swagger-spec-validator
, pytz
, msgpack
  # check inputs
, pytestCheckHook
, mock
}:

buildPythonPackage rec {
  pname = "bravado-core";
  version = "6.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/ePs3znbwamMHHzb/PD4UHq+7v0j1r1X3J3Bnb4S2VU=";
  };

  propagatedBuildInputs = [
    jsonref
    jsonschema # with optional dependencies for format
    python-dateutil
    pyyaml
    requests
    simplejson
    six
    swagger-spec-validator
    pytz
    msgpack
  ] ++ jsonschema.optional-dependencies.format;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    mock
  ];

  pythonImportsCheck = [
    "bravado_core"
  ];

  disabledTestPaths = [
    # skip benchmarks
    "tests/profiling"
    # take too long to run
    "tests/spec/Spec"
  ];

  meta = with lib; {
    description = "Library for adding Swagger support to clients and servers";
    homepage = "https://github.com/Yelp/bravado-core";
    changelog = "https://github.com/Yelp/bravado-core/blob/v${version}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vanschelven nickcao ];
  };
}
