{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  clang,
  # dependencies
  pyyaml,
  blst,
  # checkPhase dependencies
  python,
}:

buildPythonPackage rec {
  pname = "ckzg";
  version = "2.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ethereum";
    repo = "c-kzg-4844";
    tag = "v${version}";
    hash = "sha256-692u5EFiA3sfJbd3CUdTO/9LP2y4+WjLZZaFkY9vlP4=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [ clang ];

  dependencies = [
    pyyaml
    blst
  ];

  postPatch =
    # unvendor "blst"
    ''
      substituteInPlace setup.py \
        --replace-fail '"build_ext": CustomBuild,' ""
    '';

  checkPhase = ''
    runHook preCheck

    cd bindings/python
    ${python.interpreter} tests.py

    runHook postCheck
  '';

  pythonImportsCheck = [ "ckzg" ];

  meta = {
    description = "Minimal implementation of the Polynomial Commitments API for EIP-4844 and EIP-7594";
    homepage = "https://github.com/ethereum/c-kzg-4844";
    changelog = "https://github.com/ethereum/c-kzg-4844/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hellwolf ];
  };
}
