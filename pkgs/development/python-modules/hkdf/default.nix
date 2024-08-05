{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "hkdf";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "casebeer";
    repo = "python-hkdf";
    rev = "cc3c9dbf0a271b27a7ac5cd04cc1485bbc3b4307";
    hash = "sha256-i3vJzUI7dpZbgZkz7Agd5RAeWisNWftdk/mkJBZkkLg=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "hkdf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "tests.py" ];

  meta = {
    description = "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)";
    homepage = "https://github.com/casebeer/python-hkdf";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
