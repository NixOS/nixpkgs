{
  lib,
  asn1crypto,
  buildPythonPackage,
  cython,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-pkcs11";
  version = "0.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danni";
    repo = "python-pkcs11";
    tag = "v${version}";
    sha256 = "sha256-3OfX7PlVyH8X8oJs0DpmZp0xbWzdahVXOvgnKwCDrPo=";
  };

  build-system = [
    cython
    setuptools-scm
  ];

  dependencies = [
    asn1crypto
  ];

  # Test require additional setup
  doCheck = false;

  pythonImportsCheck = [ "pkcs11" ];

  meta = {
    changelog = "https://github.com/pyauth/python-pkcs11/releases/tag/${src.tag}";
    description = "PKCS#11/Cryptoki support for Python";
    homepage = "https://github.com/danni/python-pkcs11";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
