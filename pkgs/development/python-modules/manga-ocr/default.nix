{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
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
  pythonOlder,
}:
buildPythonPackage rec {
  pname = "manga-ocr";
  version = "0.1.11";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "kha-white";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-cLmgHBt6HvhY6Hb9yQ425Gk181axnMr+Mp2LxSmPoDg=";
  };

  preBuild = ''
    # remove subproject dedicated to model training
    rm -rf manga_ocr_dev
    # copy assets/example.jpg inside the package
    # required by https://github.com/kha-white/manga-ocr/blob/ba1b0d94a8ef6676b618ba4e5ffe8ce2ab655270/manga_ocr/ocr.py#L27-L30
    # see also package_data.patch
    mkdir manga_ocr/assets
    cp assets/example.jpg manga_ocr/assets/example.jpg
  '';

  patches = [
    # instruct setuptool to copy assets/example.jpg to package when building wheel
    ./package_data.patch
  ];

  propagatedBuildInputs = [
    # taken from requirements.txt
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
