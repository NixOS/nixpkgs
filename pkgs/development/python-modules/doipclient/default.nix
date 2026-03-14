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
    pytest-mock
  ];

  pythonImportsCheck = [ "doipclient" ];

  meta = {
    description = "Enables Diagnostic over IP communication with automotive ECUs";
    homepage = "https://github.com/jacobschaer/python-doipclient";
    changelog = "https://github.com/jacobschaer/python-doipclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      mana-byte
      RossSmyth
    ];
  };
})
