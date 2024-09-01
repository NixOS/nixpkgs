{
  lib,
  awscrt,
  buildPythonPackage,
  fetchPypi,
  jmespath,
  jsonschema,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.35.10"; # N.B: if you change this, change boto3 and awscli to a matching version
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bIoTd7Zjag2AIYEV4c1BvM66Ci8FC3nCBvTPjQAsVNc=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  build-system = [
    setuptools
  ];

  dependencies = [
    jmespath
    python-dateutil
    urllib3
  ];

  nativeCheckInputs = [
    jsonschema
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/functional"
  ];

  pythonImportsCheck = [ "botocore" ];

  passthru.optional-dependencies = {
    crt = [ awscrt ];
  };

  meta = with lib; {
    description = "Low-level interface to a growing number of Amazon Web Services";
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
