{ stdenv, pkgs, buildPythonPackage, fetchurl, isPy27, fetchpatch
, cython, SDL2, SDL2_image, SDL2_ttf, SDL2_mixer, libjpeg, libpng }:

buildPythonPackage rec {
  pname = "pygame_sdl2";
  version = "2.1.0";
  renpy_version = "6.99.14";
  name = "${pname}-${version}-${renpy_version}";

  src = fetchurl {
    url = "https://www.renpy.org/dl/${renpy_version}/pygame_sdl2-${version}-for-renpy-${renpy_version}.tar.gz";
    sha256 = "1zsnb2bivbwysgxmfg9iv12arhpf3gqkmqinhciz955hlqv016b9";
  };

  # force rebuild of headers needed for install
  prePatch = ''
    rm -rf gen gen3
  '';

  patches = [
    # fix for recent sdl2
    (fetchpatch {
      url = "https://github.com/apoleon/pygame_sdl2/commit/ced6051f4a4559a725804cc58c079e1efea0a573.patch";
      sha256 = "08rqjzvdlmmdf8kyd8ws5lzjy1mrwnds4fdy38inkyw7saydcxyr";
    })
  ];

  buildInputs = [
    SDL2 SDL2_image SDL2_ttf SDL2_mixer
    cython libjpeg libpng
  ];


  doCheck = isPy27; # python3 tests are non-functional

  postInstall = ''
    ( cd "$out"/include/python*/ ;
      ln -s pygame-sdl2 pygame_sdl2 || true ; )
  '';

  meta = with stdenv.lib; {
    description = "A reimplementation of parts of pygame API using SDL2";
    homepage    = "https://github.com/renpy/pygame_sdl2";
    # Some parts are also available under Zlib License
    license     = licenses.lgpl2;
    maintainers = with maintainers; [ raskin ];
  };
}
