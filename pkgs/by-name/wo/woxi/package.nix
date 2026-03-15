{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "woxi";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "ad-si";
    repo = "woxi";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ra7IEPhics8BhBpQpjqSIYRlgETAquGCyuqiDopFNxE=";
  };

  cargoHash = "sha256-CW59x2a/n6rFhdJjIBz5TwkX9Bg3dE/1mH/IZh/LFZI=";

  meta = {
    description = "Wolfram Language / Mathematica reimplementation in Rust";
    homepage = "https://woxi.ad-si.com/";
    license = lib.licenses.agpl3Only;
    mainProgram = "woxi";
  };
})
