{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  certifi,
  python-dateutil,
  six,
  urllib3,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "brevo-python";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getbrevo";
    repo = "brevo-python";
    tag = "v${version}";
    hash = "sha256-VYj1r69pgKgNCXzxRqvwlj5w+y3IIu21bsZJAe/7zf8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    certifi
    python-dateutil
    six
    urllib3
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # broken import; https://github.com/getbrevo/brevo-python/issues/2
    "test/test_configuration.py"
  ];

  pythonImportsCheck = [ "brevo_python" ];

  meta = {
    description = "Fully-featured Python API client to interact with Brevo";
    homepage = "https://github.com/getbrevo/brevo-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
