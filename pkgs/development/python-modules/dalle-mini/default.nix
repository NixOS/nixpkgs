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
  version = "0.1.4";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UwCcoKbGxZT5XB+Mtv8kAHFdj0iLw8U1Ayo60y3Tm7U=";
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
