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
}:

buildPythonPackage (finalAttrs: {
  pname = "native-sparse-attention-pytorch";
  version = "0.2.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "lucidrains";
    repo = "native-sparse-attention-pytorch";
    rev = finalAttrs.version;
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

  enabledTestPaths = [ "tests/" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Sparse Attention";
    homepage = "https://github.com/lucidrains/native-sparse-attention-pytorch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jherland ];
  };
})
