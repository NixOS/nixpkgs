{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  einops,
  einx,
  jaxtyping,
  local-attention,
  rotary-embedding-torch,
  torch,
  tqdm,
  wandb,
  pytest,
  pytestCheckHook,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "native-sparse-attention-pytorch";
  version = "0.2.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchPypi {
    pname = "native_sparse_attention_pytorch";
    inherit (finalAttrs) version;
    hash = "sha256-e5SBu1LuVl1QmIaMc0UoXog0IkiRX/jj5i9/6UW+LaA=";
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

  optional-dependencies = {
    examples = [
      tqdm
      wandb
    ];
    test = [
      pytest
      tqdm
    ];
  };

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
    homepage = "https://pypi.org/project/native-sparse-attention-pytorch";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jlesquembre ];
  };
})
