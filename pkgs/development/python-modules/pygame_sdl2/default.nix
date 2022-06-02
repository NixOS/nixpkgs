{ lib, buildPythonPackage, fetchurl, isPy27
, cython, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer, libjpeg, libpng }:

buildPythonPackage rec {
  pname = "pygame_sdl2";
  version = "2.1.0";
  renpy_version = "7.2.0";
  name = "${pname}-${version}-${renpy_version}";

  src = fetchurl {
    url = "https://www.renpy.org/dl/${renpy_version}/pygame_sdl2-${version}-for-renpy-${renpy_version}.tar.gz";
    sha256 = "1amgsb6mm8ssf7vdcs5dr8rlxrgyhh29m4i573z1cw61ynd7vgcw";
  };

  # force rebuild of headers needed for install
  prePatch = ''
    rm -rf gen gen3
  '';

  nativeBuildInputs = [
    SDL2.dev cython
  ];

  buildInputs = [
    SDL2 SDL2_image SDL2_ttf SDL2_mixer
    libjpeg libpng
  ];


  doCheck = isPy27; # python3 tests are non-functional

  postInstall = ''
    ( cd "$out"/include/python*/ ;
      ln -s pygame-sdl2 pygame_sdl2 || true ; )
  '';

  meta = with lib; {
    description = "A reimplementation of parts of pygame API using SDL2";
    homepage    = "https://github.com/renpy/pygame_sdl2";
    # Some parts are also available under Zlib License
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ raskin ];
  };
}
