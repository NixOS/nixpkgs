{
  lib,
  asn1crypto,
  buildPythonPackage,
  cached-property,
  cython,
  fetchFromGitHub,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "python-pkcs11";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "danni";
    repo = "python-pkcs11";
    tag = "v${version}";
    sha256 = "sha256-iCfcVVzAwwg69Ym1uVimSzYZBQmC+Yppl5YXDaLIcqc=";
  };

  nativeBuildInputs = [
    cython
    setuptools-scm
  ];

  propagatedBuildInputs = [
    cached-property
    asn1crypto
  ];

  # Test require additional setup
  doCheck = false;

  pythonImportsCheck = [ "pkcs11" ];

  meta = with lib; {
    description = "PKCS#11/Cryptoki support for Python";
    homepage = "https://github.com/danni/python-pkcs11";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
