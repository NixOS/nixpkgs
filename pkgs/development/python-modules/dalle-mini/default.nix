{ lib
, buildPythonPackage
, fetchPypi
, pythonRelaxDepsHook
, einops
, emoji
, flax
, ftfy
, jax
, jaxlib
, pillow
, transformers
, unidecode
, wandb
}:

buildPythonPackage rec {
  pname = "dalle-mini";
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k4XILjNNz0FPcAzwPEeqe5Lj24S2Y139uc9o/1IUS1c=";
  };

  format = "setuptools";

  # Those two patches are caused by changes in the latest jax versions.
  # The devs have chosen to pin jax to an older version for now.
  # See https://github.com/borisdayma/dalle-mini/commit/8fd8b63f7fe028c4926c4761aaa4f11e593e4526
  patches = [
    ./fix-partitionspec-import.patch
    ./remove-deprecated-shared-array.patch
  ];

  pythonRelaxDeps = [
    "flax"
    "jax"
    "transformers"
  ];

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = [
    einops
    emoji
    flax
    ftfy
    jax
    jaxlib
    pillow
    transformers
    unidecode
    wandb
  ];

  doCheck = false; # no upstream tests

  pythonImportsCheck = [ "dalle_mini" ];

  meta = with lib; {
    description = "Generate images from a text prompt";
    homepage = "https://github.com/borisdayma/dalle-mini";
    license = licenses.asl20;
    maintainers = with maintainers; [ r-burns ];
  };
}
