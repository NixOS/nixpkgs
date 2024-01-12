{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, jmespath
, urllib3
, pytestCheckHook
, jsonschema
, awscrt
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.33.6"; # N.B: if you change this, change boto3 and awscli to a matching version
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k4BWurgxgp+Q4J7NcN1rKVr9UrFIL1WC7noR2CQ9lmE=";
  };

  propagatedBuildInputs = [
    python-dateutil
    jmespath
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [
    "botocore"
  ];

  passthru.optional-dependencies = {
    crt = [ awscrt ];
  };

  meta = with lib; {
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    description = "A low-level interface to a growing number of Amazon Web Services";
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
