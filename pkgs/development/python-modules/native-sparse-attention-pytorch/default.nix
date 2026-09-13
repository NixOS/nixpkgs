{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  einops,
  einx,
  jaxtyping,
  local-attention,
  rotary-embedding-torch,
  torch,
  tqdm,
  pytestCheckHook,
  nix-update-script,

  # passthru
  native-sparse-attention-pytorch,
}:

buildPythonPackage (finalAttrs: {
  pname = "native-sparse-attention-pytorch";
  version = "0.2.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "native-sparse-attention-pytorch";
    tag = finalAttrs.version;
    hash = "sha256-ec9eMHKP67BiybrHympRAZgbtl6pFLFRbNilmzZyQw8=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    einops
    einx
    jaxtyping
    local-attention
    rotary-embedding-torch
    torch
  ];

  pythonImportsCheck = [
    "native_sparse_attention_pytorch"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    tqdm
  ];

  disabledTestPaths = [
    # The following fails with: RuntimeError: Found no NVIDIA driver on your system.
    "test_flex_masks.py"
    # The following fails on: assert torch.cuda.is_available()
    "test_triton_nsa.py"
  ];

  passthru.gpuCheck = native-sparse-attention-pytorch.overridePythonAttrs (old: {
    requiredSystemFeatures = [ "cuda" ];

    # Run all tests, including the ones that need a GPU
    disabledTestPaths = [ ];
  });

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Sparse Attention";
    homepage = "https://github.com/lucidrains/native-sparse-attention-pytorch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
