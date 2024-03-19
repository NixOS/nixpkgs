{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, setuptools
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
  version = "6.6.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kyHmZNPl5lLKmm5i3TSi8Tfi96mQHqaiyBfceBJcOdw=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
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
  ] ++ jsonschema.optional-dependencies.format-nongpl;

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
