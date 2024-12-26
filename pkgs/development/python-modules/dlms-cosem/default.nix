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
  version = "24.1.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pwitab";
    repo = "dlms-cosem";
    rev = "refs/tags/${version}";
    hash = "sha256-NeTaU8i18Zb39Y2JnYzr87Ozt7Rj074xusL4xaNe0q0=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
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

  meta = with lib; {
    description = "Python module to parse DLMS/COSEM";
    homepage = "https://github.com/pwitab/dlms-cosem";
    changelog = "https://github.com/pwitab/dlms-cosem/blob/${version}/HISTORY.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
