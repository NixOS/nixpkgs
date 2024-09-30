{
  lib,
  fetchFromGitHub,
  clang,
  buildPythonPackage,
  python,
  pythonOlder,
  pyyaml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ckzg";
  version = "2.0.1";

  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "c-kzg-4844";
    rev = "refs/tags/v${version}";
    hash = "sha256-mpDVuAghIPplopr/mij9LSEjbVEwmZw3Agyp2DNBbNI=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];
  nativeBuildInputs = [ clang ];

  nativeCheckInputs = [ pyyaml ];
  checkPhase = ''
    runHook preCheck
    cd bindings/python
    ${python.interpreter} tests.py
  '';

  pythonImportsCheck = [ "ckzg" ];

  meta = {
    changelog = "https://github.com/ethereum/c-kzg-4844/releases/tag/v${version}";
    description = "Minimal implementation of the Polynomial Commitments API for EIP-4844 and EIP-7594";
    homepage = "https://github.com/ethereum/c-kzg-4844";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.FlorianFranzen ];
  };
}
