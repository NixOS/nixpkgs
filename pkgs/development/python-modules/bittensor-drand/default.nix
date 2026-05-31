{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  rustPlatform,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "bittensor-drand";
  version = "1.3.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "latent-to";
    repo = "bittensor-drand";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0GizpmKGWbDjWCIAF1kPdz2sjn8B/e0qSIHmDqlDzZc=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-JasDf3qXzB6ddp1NjC+xtozsggwyk2nQbRw/Lbt02Kg=";
  };

  nativeBuildInputs = with rustPlatform; [
    cargoSetupHook
    maturinBuildHook
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  # remove source package so tests import the installed Rust extension, not the stub __init__.py
  preCheck = ''
    rm -rf bittensor_drand
  '';

  # All tests in test_commit_reveal.py and most in test_all_functions.py call
  # the live drand network beacon, which is unavailable in the build sandbox.
  disabledTests = [
    "test_get_latest_round"
    "test_encrypt_and_decrypt"
    "test_encrypt_at_round_and_decrypt"
    "test_get_signature_for_round"
    "test_decrypt_with_signature"
    "test_batch_decryption_optimization"
    "test_get_encrypted_commitment"
    "test_get_encrypted_commit"
    "test_get_encrypted_commits"
  ];

  pythonImportsCheck = [ "bittensor_drand" ];

  meta = {
    description = "Bittensor drand integration for commit-reveal";
    homepage = "https://github.com/latent-to/bittensor-drand";
    changelog = "https://github.com/latent-to/bittensor-drand/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilyanni ];
  };
})
