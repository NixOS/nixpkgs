{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  fetchFromGitHub,
  hatchling,
  huggingface-hub,
  loguru,
  misaki,
  numpy,
  torch,
  transformers,
  addict,
  num2words,
  spacy,
  phonemizer,
  espeakng-loader,
}:

buildPythonPackage rec {
  pname = "kokoro";
  version = "0.9.4";
  pyproject = true;
  disabled = pythonAtLeast "3.13";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+/YzJieX+M9G/awzFc+creZ9yLdiwP7M8zSJJ3L7msQ=";
  };

  build-system = [ hatchling ];

  buildInputs = [
    huggingface-hub
    loguru
    misaki
    numpy
    torch
    transformers
  ];

  dependencies = [
    addict
    num2words
    spacy
    (phonemizer.overrideAttrs (oldAttrs: {
      version = "3.3.2-unstable-2025-01-05";

      src = fetchFromGitHub {
        owner = "thewh1teagle";
        repo = "phonemizer-fork";
        rev = "cc1db4bfaf688fdfb8275fd83d218f06411455e6";
        hash = "sha256-4mydpeLRGV9fp4gG7SkT//f2E9YzYFprnqP1kWItaB4=";
      };
    }))
    espeakng-loader
  ];

  pythonImportsCheck = [ "kokoro" ];

  meta = {
    description = "Inference library for Kokoro-82M";
    homepage = "https://github.com/hexgrad/kokoro";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ emaryn ];
  };
}
