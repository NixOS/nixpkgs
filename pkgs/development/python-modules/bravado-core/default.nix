{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # build inputs
  jsonref,
  jsonschema,
  python-dateutil,
  pyyaml,
  requests,
  simplejson,
  six,
  swagger-spec-validator,
  pytz,
  msgpack,
  # check inputs
  pytestCheckHook,
  mock,
}:

buildPythonPackage rec {
  pname = "bravado-core";
  version = "6.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "bravado-core";
    rev = "v${version}";
    hash = "sha256-tMrGNezHtmSwuZOdTI+dMIFZ8SWi38LoOWevdwHcKr8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    jsonref
    jsonschema # jsonschema[format-nongpl]
    python-dateutil
    pyyaml
    requests
    simplejson
    six
    swagger-spec-validator
    pytz
    msgpack
  ]
  ++ jsonschema.optional-dependencies.format-nongpl;

  nativeCheckInputs = [
    pytestCheckHook
    mock
  ];

  pythonImportsCheck = [ "bravado_core" ];

  disabledTestPaths = [
    # skip benchmarks
    "tests/profiling"
    # take too long to run
    "tests/spec/Spec"
  ];

  meta = {
    description = "Library for adding Swagger support to clients and servers";
    homepage = "https://github.com/Yelp/bravado-core";
    changelog = "https://github.com/Yelp/bravado-core/blob/v${version}/CHANGELOG.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      vanschelven
      nickcao
    ];
  };
}
