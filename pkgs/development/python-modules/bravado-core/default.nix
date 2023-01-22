{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fqdn
, idna
, isoduration
, jsonpointer
, jsonref
, jsonschema
, mock
, msgpack
, mypy-extensions
, pytest-benchmark
, pytestCheckHook
, python-dateutil
, pythonOlder
, pytz
, pyyaml
, rfc3987
, rfc3339-validator
, simplejson
, six
, strict-rfc3339
, swagger-spec-validator
, uri-template
, webcolors
}:

buildPythonPackage rec {
  pname = "bravado-core";
  version = "5.17.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-okQA4YJq0lyVJuDzD8mMRlOS/K3gf1qRUpw/5M0LlZE=";
  };

  propagatedBuildInputs = [
    jsonref
    jsonschema
    msgpack
    python-dateutil
    pytz
    pyyaml
    simplejson
    six
    swagger-spec-validator

    # the following packages are included when jsonschema (3.2) is installed
    # as jsonschema[format], which reflects what happens in setup.py
    fqdn
    idna
    isoduration
    jsonpointer
    rfc3987
    rfc3339-validator
    strict-rfc3339
    uri-template
    webcolors
  ];

  nativeCheckInputs = [
    mypy-extensions
    pytestCheckHook
    mock
    pytest-benchmark
  ];

  pythonImportsCheck = [
    "bravado_core"
  ];

  pytestFlagsArray = [
    "--benchmark-skip"
  ];

  disabledTestPaths = [
    # Tests are out-dated (not supporting later modules releases, e.g., jsonschema)
    "tests/_decorators_test.py"
    "tests/formatter"
    "tests/marshal"
    "tests/model"
    "tests/operation"
    "tests/param"
    "tests/request"
    "tests/resource"
    "tests/response"
    "tests/schema"
    "tests/security_test.py"
    "tests/spec"
    "tests/swagger20_validator"
    "tests/unmarshal"
    "tests/validate"
  ];

  disabledTests = [
    "test_petstore_spec"
  ];

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "Library for adding Swagger support to clients and servers";
    homepage = "https://github.com/Yelp/bravado-core";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vanschelven ];
  };
}
