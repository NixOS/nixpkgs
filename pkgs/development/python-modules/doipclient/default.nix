{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  udsoncan,
  pytestCheckHook,
  pytest-mock,
}:
buildPythonPackage (finalAttrs: {
  pname = "doipclient";
  version = "1.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jacobschaer";
    repo = "python-doipclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Hufp5nKuvURKVFwc0H94PrWg04m6zF+y8gZS0HqQ94g=";
  };

  build-system = [ setuptools ];

  dependencies = [
    udsoncan
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  checkInputs = [
    pytest-mock
  ];

  pythonImportsCheck = [ "doipclient" ];

  meta = {
    description = "Python 3 Diagnostic over IP (DoIP) client which can be used for communicating with modern ECU's over automotive ethernet";
    homepage = "https://github.com/jacobschaer/python-doipclient";
    changelog = "https://github.com/jacobschaer/python-doipclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ RossSmyth ];
  };
})
