{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  toml,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bt-decode";
  version = "0.8.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "bt-decode";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jpCnYKoTVq2NCxE1vZhJzSagXtx43efDSdA5jWsZ95k=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-qj4S1104HaFs6JePwgBjAI/4z7aH71Wq9CDvnSxlXmM=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  dependencies = [ toml ];

  nativeCheckInputs = [ pytestCheckHook ];

  # these tests compare against bittensor, which is not in nixpkgs
  disabledTestPaths = [
    "tests/test_decode_delegate_info.py"
    "tests/test_decode_neurons.py"
    "tests/test_decode_stake_info.py"
    "tests/test_decode_subnet_hyp.py"
    "tests/test_decode_subnet_info.py"
  ];

  pythonImportsCheck = [ "bt_decode" ];

  meta = {
    description = "Fast SCALE decoding of Bittensor data structures";
    longDescription = "A python wrapper around the rust scale-codec crate for fast scale-decoding of Bittensor data structures.";
    homepage = "https://github.com/latent-to/bt-decode";
    changelog = "https://github.com/latent-to/bt-decode/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
