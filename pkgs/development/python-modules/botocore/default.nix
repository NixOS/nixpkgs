{ lib
, buildPythonPackage
, fetchPypi
, python-dateutil
, jmespath
, docutils
, urllib3
, pytestCheckHook
, jsonschema
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.29.79"; # N.B: if you change this, change boto3 and awscli to a matching version

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-x97UQGK+07kolEz7CeFXjtP+0OTJjeTyM/PCBWqNSR4=";
  };

  propagatedBuildInputs = [
    python-dateutil
    jmespath
    docutils
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  doCheck = true;

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [
    "botocore"
  ];

  meta = with lib; {
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    description = "A low-level interface to a growing number of Amazon Web Services";
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
