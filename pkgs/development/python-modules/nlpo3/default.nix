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
  version = "1.4.0-unstable-2024-11-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "PyThaiNLP";
    repo = "nlpo3";
    rev = "280c47b7f98e88319c1a4ac2c7a2e5f273c00621";
    hash = "sha256-bEN2SaINfqvTIPSROXApR3zoLdjZY0h6bdAzbMHrJdM=";
  };

  postPatch = ''
    substituteInPlace tests/test_tokenize.py \
      --replace-fail "data/test_dict.txt" "$src/nlpo3-python/tests/data/test_dict.txt"
  '';

  sourceRoot = "${src.name}/nlpo3-python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src sourceRoot;
    hash = "sha256-S5nDOz/3ZenvMs8ruybEu5ULefeYGPIKO8kCW3dTa+E=";
  };

  preCheck = ''
    rm -r nlpo3
  '';

  nativeBuildInputs = [
    rustPlatform.cargoSetupHook
    rustc
    cargo
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libiconv ];

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
