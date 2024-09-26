{
  lib,
  stdenv,
  buildPythonPackage,
  pythonAtLeast,
  unittestCheckHook,
  rustPlatform,
  fetchFromGitHub,
  rustc,
  cargo,
  libiconv,
  setuptools,
  setuptools-rust,
}:

buildPythonPackage rec {
  pname = "nlpo3";
  version = "1.3.0";
  pyproject = true;

  # failing build on python 3.12
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

  preCheck = ''
    rm -r nlpo3
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv ];

  build-system = [
    setuptools
    setuptools-rust
  ];

  nativeCheckInputs = [ unittestCheckHook ];

  unittestFlagsArray = [
    "-s"
    "tests"
    "-v"
  ];

  pythonImportsCheck = [ "nlpo3" ];

  meta = {
    description = "Thai Natural Language Processing library in Rust, with Python and Node bindings";
    homepage = "https://github.com/PyThaiNLP/nlpo3";
    changelog = "https://github.com/PyThaiNLP/nlpo3/releases/tag/nlpo3-python-v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ vizid ];
  };
}
