{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  setuptools-scm,
  fire,
  fugashi,
  jaconv,
  loguru,
  numpy,
  pillow,
  pyperclip,
  torch,
  transformers,
  unidic-lite,
}:

buildPythonPackage rec {
  pname = "manga-ocr";
  version = "0.1.15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "manga-ocr";
    tag = "v${version}";
    hash = "sha256-Inev2iGcDsudUV4zNzssDqglj0t6Uh/CbW3RuIDnbKE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    fire
    fugashi
    jaconv
    loguru
    numpy
    pillow
    pyperclip
    torch
    transformers
    unidic-lite
  ];

  meta = {
    mainProgram = "manga_ocr";
    description = "Optical character recognition for Japanese text, with the main focus being Japanese manga";
    homepage = "https://github.com/kha-white/manga-ocr";
    changelog = "https://github.com/kha-white/manga-ocr/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
