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
  pythonRelaxDepsHook,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "botocore";
  version = "1.34.87"; # N.B: if you change this, change boto3 and awscli to a matching version
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-o6TYV/CUHZih5c6M1kw5BiJx/qC+TZ89DWr/bLWBI7k=";
  };

  pythonRelaxDeps = [ "urllib3" ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = [
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
    description = "A low-level interface to a growing number of Amazon Web Services";
    homepage = "https://github.com/boto/botocore";
    changelog = "https://github.com/boto/botocore/blob/${version}/CHANGELOG.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
