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
  version = "2.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Synss";
    repo = "python-mbedtls";
    rev = version;
    hash = "sha256-eKKb12G/0QAcwtv5Yk/92QXhMipeKOfKR1JEaNHDIlg=";
  };

  build-system = [
    cython
    setuptools
  ];

  buildInputs = [ mbedtls_2 ];

  dependencies = [
    certifi
    typing-extensions
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mbedtls" ];

  meta = with lib; {
    description = "Cryptographic library with an mbed TLS back end";
    homepage = "https://github.com/Synss/python-mbedtls";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
