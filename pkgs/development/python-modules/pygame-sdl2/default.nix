{
  lib,
  buildPythonPackage,
  fetchurl,
  isPy27,
  renpy,
  cython_0,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  libjpeg,
  libpng,
  setuptools,
}:
let
  pname = "pygame-sdl2";
  version = "2.1.0";
  renpy_version = renpy.base_version;
in

buildPythonPackage {
  inherit pname version;
  name = "${pname}-${version}-${renpy_version}";
  pyproject = true;

  src = fetchurl {
    url = "https://www.renpy.org/dl/${renpy_version}/pygame_sdl2-${version}+renpy${renpy_version}.tar.gz";
    hash = "sha256-Zib39NyQ1pGVCWPrK5/Tl3dAylUlmKZKxU8pf+OpAdY=";
  };

  # force rebuild of headers needed for install
  prePatch = ''
    rm -rf gen gen3
  '';

  # Remove build tag which produces invaild version
  postPatch = ''
    sed -i '2d' setup.cfg
  '';

  nativeBuildInputs = [
    SDL2.dev
    cython_0
    setuptools
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_ttf
    SDL2_mixer
    libjpeg
    libpng
  ];

  doCheck = isPy27; # python3 tests are non-functional

  meta = {
    description = "Reimplementation of parts of pygame API using SDL2";
    homepage = "https://github.com/renpy/pygame_sdl2";
    license = with lib.licenses; [
      lgpl2
      zlib
    ];
    maintainers = with lib.maintainers; [ raskin ];
  };
}
