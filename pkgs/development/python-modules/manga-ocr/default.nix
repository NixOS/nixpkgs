{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

with python3Packages;

buildPythonPackage rec {
  pname = "manga-ocr";
  version = "0.1.14";
  disabled = pythonOlder "3.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = "manga-ocr";
    tag = "v${version}";
    hash = "sha256-fCLgFeo6GYPSpCX229TK2MXTKt3p1tQV06phZYD6UeE=";
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "numpy<2" "numpy"
  '';

  meta = with lib; {
    description = "Optical character recognition for Japanese text, with the main focus being Japanese manga";
    homepage = "https://github.com/kha-white/manga-ocr";
    changelog = "https://github.com/kha-white/manga-ocr/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ laurent-f1z1 ];
  };
}
