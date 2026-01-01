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
  pythonOlder,
  setuptools,
  structlog,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "dlms-cosem";
  version = "25.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

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

<<<<<<< HEAD
  meta = {
    description = "Python module to parse DLMS/COSEM";
    homepage = "https://github.com/pwitab/dlms-cosem";
    changelog = "https://github.com/pwitab/dlms-cosem/blob/${src.tag}/HISTORY.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Python module to parse DLMS/COSEM";
    homepage = "https://github.com/pwitab/dlms-cosem";
    changelog = "https://github.com/pwitab/dlms-cosem/blob/${src.tag}/HISTORY.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
