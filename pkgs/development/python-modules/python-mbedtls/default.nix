{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  certifi,
  cython,
  mbedtls_2,
  pytestCheckHook,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "python-mbedtls";
  version = "2.8.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Synss";
    repo = "python-mbedtls";
    rev = version;
    hash = "sha256-gMFludfAprQ/1JR77Ee6/xVvGLJ9pY1LrouLpSKVrzk=";
  };

  nativeBuildInputs = [
    cython
    setuptools
  ];

  buildInputs = [ mbedtls_2 ];

  propagatedBuildInputs = [
    certifi
    typing-extensions
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mbedtls" ];

  meta = with lib; {
    description = "Cryptographic library with an mbed TLS back end";
    homepage = "https://github.com/Synss/python-mbedtls";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
