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
  version = "0.1.5";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-k4XILjNNz0FPcAzwPEeqe5Lj24S2Y139uc9o/1IUS1c=";
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
