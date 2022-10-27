{ lib
, buildPythonPackage
, fetchPypi
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
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/wGIuYSWEUgJmeRN5K9/xuoCs+hpFX4/Tu1un1C4ljk=";
  };

  format = "setuptools";

  buildInputs = [
    jaxlib
  ];

  propagatedBuildInputs = [
    einops
    emoji
    flax
    ftfy
    jax
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
