{
  lib,
  asn1crypto,
  attrs,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pyserial,
  pytestCheckHook,
  python-dateutil,
  setuptools,
  structlog,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dlms-cosem";
  version = "25.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pwitab";
    repo = "dlms-cosem";
    tag = version;
    hash = "sha256-ZsF+GUVG9bZNZE5daROQJIZZgqpjAkB/bFyre2oGu+E=";
  };

  build-system = [ setuptools ];

  dependencies = [
    asn1crypto
    attrs
    cryptography
    pyserial
    python-dateutil
    structlog
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "dlms_cosem" ];

  meta = {
    description = "Python module to parse DLMS/COSEM";
    homepage = "https://github.com/pwitab/dlms-cosem";
    changelog = "https://github.com/pwitab/dlms-cosem/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
