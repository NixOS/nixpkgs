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
  version = "1.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "getbrevo";
    repo = "brevo-python";
    tag = "v${version}";
    hash = "sha256-XOUFyUrqVlI7Qr4uzeXr6GJuQ+QTVhsueT1xxVQMm14=";
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

  pythonImportsCheck = [ "brevo_python" ];

  meta = {
    description = "Fully-featured Python API client to interact with Brevo";
    homepage = "https://github.com/getbrevo/brevo-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ soyouzpanda ];
  };
}
