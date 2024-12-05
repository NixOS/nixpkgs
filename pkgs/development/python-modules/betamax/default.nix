{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "betamax";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gjFuFnm8aHnjyDMY0Ba1S3ySJf8IxEYt5IE+IgONX5Q=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "betamax" ];

  disabledTestPaths = [
    # Tests require network access
    "tests/integration/test_hooks.py"
    "tests/integration/test_placeholders.py"
    "tests/integration/test_record_modes.py"
    "tests/integration/test_unicode.py"
    "tests/regression/test_gzip_compression.py"
    "tests/regression/test_requests_2_11_body_matcher.py"
  ];

  meta = with lib; {
    description = "A VCR imitation for requests";
    homepage = "https://betamax.readthedocs.org/";
    changelog = "https://github.com/betamaxpy/betamax/blob/${version}/HISTORY.rst";
    license = licenses.asl20;
    maintainers = with maintainers; [ pSub ];
  };
}
