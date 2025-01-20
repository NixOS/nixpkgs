{
  lib,
  fetchFromGitLab,
  buildDunePackage,
  pkg-config,
  findlib,
  dune-configurator,
  cppo,
  graphics,
  lablgtk,
  libexif,
  libpng,
  libjpeg,
  libtiff,
  giflib,
  libwebp,
  freetype,
  stdio,
  xorg,
}:

buildDunePackage rec {
  pname = "camlimages";
  version = "5.0.5-unstable-2024-11-23";

  minimalOCamlVersion = "5.0";

  src = fetchFromGitLab {
    owner = "camlspotter";
    repo = pname;
    rev = "a9f60a4420e05d3de4ac5383c6b371d5c4d3ed80";
    hash = "sha256-rRD+6HrTgODvc0ZlW2taCXr8dBRVvwuJ0tkPNFY6ddU=";
  };

  nativeBuildInputs = [ cppo pkg-config ];
  buildInputs = [
    dune-configurator
    findlib
    giflib
    graphics
    lablgtk
    libexif
    libpng
    libjpeg
    libtiff
    libwebp
    freetype
    stdio
    xorg.libXpm
  ];

  meta = with lib; {
    branch = "5.0";
    inherit (src.meta) homepage;
    description = "OCaml image processing library";
    license = licenses.lgpl2;
    maintainers = [
      maintainers.vbgl
      maintainers.mt-caret
    ];
  };
}
