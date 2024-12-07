{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

with python3Packages;

buildPythonPackage rec {
  pname = "manga-ocr";
  version = "0.1.13";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "manga-ocr";
    rev = "refs/tags/v${version}";
    hash = "sha256-0EwXDMnA9SCmSsMVXnMenSFSzs74lorFNNym9y/NNsI=";
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

  meta = with lib; {
    description = "Optical character recognition for Japanese text, with the main focus being Japanese manga";
    homepage = "https://github.com/kha-white/manga-ocr";
    changelog = "https://github.com/kha-white/manga-ocr/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
