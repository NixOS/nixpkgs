{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  setuptools,

  # dependencies
  einops,
  torch,
  transformers,

  # optional-dependencies
  causal-conv1d,
  matplotlib,
  datasets,
  pytest,
}:

buildPythonPackage (finalAttrs: {
  pname = "flash-linear-attention";
  version = "0.5.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "fla-org";
    repo = "flash-linear-attention";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vxNbZ+FkxJh2E0TF09Z7ghkm8eas7Q96heeSXwgV4uU=";
  };

  build-system = [ setuptools ];

  dependencies = [
    einops
    torch
    transformers
  ];

  optional-dependencies = {
    # tilelang = [ tilelang ];
    conv1d = [ causal-conv1d ];
    benchmark = [
      matplotlib
      datasets
    ];
    test = [ pytest ];
  };

  # Tests require a GPU
  doCheck = false;

  pythonImportsCheck = [ "fla" ];

  meta = {
    description = "Triton-based implementations of causal linear attention";
    homepage = "https://github.com/fla-org/flash-linear-attention";
    changelog = "https://github.com/fla-org/flash-linear-attention/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
