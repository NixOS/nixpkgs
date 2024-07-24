{
  lib,
  buildPythonPackage,
  rustPlatform,
  fetchFromGitHub,
  pythonAtLeast,
  rustc,
  cargo,
  setuptools,
  setuptools-rust,
  wheel,
}:

buildPythonPackage rec {
  pname = "nlpo3";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonAtLeast "3.12";

  src = fetchFromGitHub {
    owner = "PyThaiNLP";
    repo = "nlpo3";
    rev = "refs/tags/nlpo3-python-v${version}";
    hash = "sha256-A1q6iieoPuRFTnyzg9y3Tp/rMx1c8nbcd1f8aaqonf4=";
  };

  sourceRoot = "${src.name}/nlpo3-python";

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src sourceRoot;
    hash = "sha256-OWXD5t4Jg9/GLgwIvM1j4Ns5oFFaHWlZbGMh3cBsIQw=";
  };

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  build-system = [
    setuptools
    setuptools-rust
    wheel
  ];

  # Fails because nlpo3 module cannot be loaded correctly
  doCheck = false;

  pythonImportsCheck = [ "nlpo3" ];

  meta = {
    description = "Thai Natural Language Processing library in Rust, with Python and Node bindings";
    homepage = "https://github.com/PyThaiNLP/nlpo3";
    changelog = "https://github.com/PyThaiNLP/nlpo3/releases/tag/nlpo3-python-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
