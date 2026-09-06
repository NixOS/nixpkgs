{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  python,
  unittestCheckHook,
  cryptography,
}:

buildPythonPackage (finalAttrs: {
  pname = "cryptomobile";
  version = "0-unstable-2025-08-30";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mitshell";
    repo = "cryptomobile";
    rev = "0857cbbf140c05c54688bdb2076c25eb8f3ddb89";
    hash = "sha256-GxRf+0QBmWHBEYMuBeFX9S63Nbbq8jyXF+L2Uj8VCXk=";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "CryptoMobile" ];

  nativeCheckInputs = [
    unittestCheckHook # for test/test_CryptoMobile.py
    cryptography
  ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} ./test/test_CM.py
    ${python.interpreter} ./test/test_ECIES.py
    ${python.interpreter} ./test/test_Milenage.py
    ${python.interpreter} ./test/test_TUAK.py

    runHook postCheck
  '';

  meta = {
    description = "Cryptography for mobile network";
    homepage = "https://github.com/mitshell/CryptoMobile";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ felbinger ];
  };
})
