{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nose,
  setuptools,
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

  nativeCheckInputs = [ nose ];

  checkPhase = ''
    runHook preCheck

    nosetests

    runHook postCheck
  '';

  meta = with lib; {
    description = "HMAC-based Extract-and-Expand Key Derivation Function (HKDF)";
    homepage = "https://github.com/casebeer/python-hkdf";
    license = licenses.bsd2;
  };
}
