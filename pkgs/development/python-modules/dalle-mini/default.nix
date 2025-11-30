{
  lib,
  buildPythonPackage,
  fetchPypi,
  fetchpatch,

  # dependencies
  einops,
  emoji,
  flax,
  ftfy,
  jax,
  jaxlib,
  orbax-checkpoint,
  pillow,
  pydantic,
  transformers,
  unidecode,
  wandb,
}:

buildPythonPackage rec {
  pname = "dalle-mini";
  version = "0.1.5";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k4XILjNNz0FPcAzwPEeqe5Lj24S2Y139uc9o/1IUS1c=";
  };

  # Fix incompatibility with the latest JAX versions
  # See https://github.com/borisdayma/dalle-mini/pull/338
  patches = [
    (fetchpatch {
      url = "https://github.com/borisdayma/dalle-mini/pull/338/commits/22ffccf03f3e207731a481e3e42bdb564ceebb69.patch";
      hash = "sha256-LIOyfeq/oVYukG+1rfy5PjjsJcjADCjn18x/hVmLkPY=";
    })
  ];

  pythonRelaxDeps = [
    "transformers"
    "jax"
    "flax"
  ];

  pythonRemoveDeps = [
    "orbax"
  ];

  dependencies = [
    einops
    emoji
    flax
    ftfy
    jax
    jaxlib
    orbax-checkpoint
    pillow
    pydantic
    transformers
    unidecode
    wandb
  ];

  doCheck = false; # no upstream tests

  pythonImportsCheck = [ "dalle_mini" ];

  meta = {
    description = "Generate images from a text prompt";
    homepage = "https://github.com/borisdayma/dalle-mini";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ r-burns ];
  };
}
