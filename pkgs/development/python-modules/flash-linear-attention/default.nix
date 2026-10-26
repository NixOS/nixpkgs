{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  einops,
  torch,
  transformers,

  # optional-dependencies
  tilelang,
  causal-conv1d,
  pandas,
  pytest-xdist,
  matplotlib,
  datasets,
  pytest,
  triton,
}:

buildPythonPackage (finalAttrs: {
  pname = "flash-linear-attention";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fla-org";
    repo = "flash-linear-attention";
    tag = "v${finalAttrs.version}";
    hash = "sha256-S09FoA3t1xnFKLimzqqcUKOJpuWHLXwq6dk3SIO1q9c=";
  };

  build-system = [ setuptools ];

  dependencies = [
    einops
    torch # Requires torch to function
    transformers
  ];

  optional-dependencies = {
    cuda = [ triton ];
    cpu = [ triton ];
    tilelang = [ tilelang ];
    conv1d = [ causal-conv1d ];
    benchmark = [
      matplotlib
      pandas
      datasets
    ];
    test = [
      pytest
      pytest-xdist
    ];
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
