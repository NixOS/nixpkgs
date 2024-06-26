{
  lib,
  botocore,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "aws-secretsmanager-caching";
  version = "1.1.2";
  pyprject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "aws_secretsmanager_caching";
    inherit version;
    hash = "sha256-hhdo+I1yA/pLA+YFDFi8Ekrv27xQLpxiqXh1+4XqteA=";
  };

  patches = [
    # Remove coverage tests from the pytest invocation in setup.cfg.
    ./remove-coverage-tests.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'pytest-runner'," ""
  '';

  build-system = [ setuptools-scm ];

  dependencies = [
    botocore
    setuptools # Needs pkg_resources at runtime.
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Integration tests require networking.
    "test/integ"
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.12") [
    # TypeError: 'float' object cannot be interpreted as an integer
    "test_calls_hook_binary"
    "test_calls_hook_string"
    "test_get_secret_binary"
    "test_get_secret_string"
    "test_invalid_json"
    "test_missing_key"
    "test_string_with_additional_kwargs"
    "test_string"
    "test_valid_json_with_mixed_args"
    "test_valid_json_with_no_secret_kwarg"
    "test_valid_json"
  ];

  pythonImportsCheck = [ "aws_secretsmanager_caching" ];

  meta = with lib; {
    description = "Client-side AWS secrets manager caching library";
    homepage = "https://github.com/aws/aws-secretsmanager-caching-python";
    changelog = "https://github.com/aws/aws-secretsmanager-caching-python/releases/tag/v${version}";
    longDescription = ''
      The AWS Secrets Manager Python caching client enables in-process caching of secrets for Python applications.
    '';
    license = licenses.asl20;
    maintainers = with maintainers; [ tomaskala ];
  };
}
