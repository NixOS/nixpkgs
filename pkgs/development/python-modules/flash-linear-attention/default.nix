{
  lib,
  buildPythonPackage,

  # build-system
  setuptools,

  # dependencies
  fla-core,
  transformers,

  # optional-dependencies
  tilelang,
  causal-conv1d,
  pandas,
  matplotlib,
  datasets,
}:

buildPythonPackage (finalAttrs: {
  pname = "flash-linear-attention";
  inherit (fla-core) version src;
  pyproject = true;
  __structuredAttrs = true;

  # Only ships fla/{layers,models}. The rest of `fla` is provided by fla-core.
  postPatch = ''
    python -c "import sys; sys.path.insert(0, 'scripts'); import build_packages; build_packages.build_split_packages('split')"
    cd split/flash-linear-attention
  '';

  build-system = [ setuptools ];

  dependencies = [
    fla-core
    transformers
  ];

  optional-dependencies = {
    tilelang = [ tilelang ];
    conv1d = [ causal-conv1d ];
    benchmark = [
      matplotlib
      pandas
      datasets
    ];
  };

  pythonImportsCheck = [
    "fla"
    "fla.layers"
    "fla.models"
  ];

  # Tests require a GPU
  doCheck = false;

  meta = {
    description = "Triton-based implementations of causal linear attention";
    homepage = "https://github.com/fla-org/flash-linear-attention";
    changelog = "https://github.com/fla-org/flash-linear-attention/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ BatteredBunny ];
  };
})
