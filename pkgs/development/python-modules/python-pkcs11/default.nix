{ lib
, asn1crypto
, buildPythonPackage
, cached-property
, cython
, fetchFromGitHub
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "python-pkcs11";
  version = "0.7.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "danni";
    repo = pname;
    rev = "v${version}";
    sha256 = "0kncbipfpsb7m7mhv5s5b9wk604h1j08i2j26fn90pklgqll0xhv";
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
