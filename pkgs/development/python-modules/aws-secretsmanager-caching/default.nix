{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, botocore
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "aws_secretsmanager_caching";
  version = "1.1.1.5";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "5cee2762bb89b72f3e5123feee8e45fbe44ffe163bfca08b28f27b2e2b7772e1";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    botocore
  ];

  patches = [
    # Remove coverage tests from the pytest invocation in setup.cfg.
    ./remove-coverage-tests.patch
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner'," ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Integration tests require networking.
    "test/integ"
  ];

  pythonImportsCheck = [
    "aws_secretsmanager_caching"
  ];

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
