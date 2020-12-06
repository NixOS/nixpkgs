{ stdenv, fetchurl, fetchpatch, SDL, libpng, libjpeg, libtiff, libungif, libXpm }:

stdenv.mkDerivation rec {
  pname = "SDL_image";
  version = "1.2.12";

  src = fetchurl {
    url    = "https://www.libsdl.org/projects/SDL_image/release/${pname}-${version}.tar.gz";
    sha256 = "16an9slbb8ci7d89wakkmyfvp7c0cval8xw4hkg0842nhhlp540b";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2017-2887";
      url = "https://hg.libsdl.org/SDL_image/raw-diff/318484db0705/IMG_xcf.c";
      sha256 = "140dyszz9hkpgwjdiwp1b7jdd8f8l5d862xdaf3ml4cimga1h5kv";
    })
  ];

  configureFlags = [
    # Disable its dynamic loading or dlopen will fail because of no proper rpath
    "--disable-jpg-shared"
    "--disable-png-shared"
    "--disable-tif-shared"
  ] ++ stdenv.lib.optional stdenv.isDarwin "--disable-sdltest";

  buildInputs = [ SDL libpng libjpeg libtiff libungif libXpm ];

  meta = with stdenv.lib; {
    description = "SDL image library";
    homepage    = "http://www.libsdl.org/projects/SDL_image/";
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
    license     = licenses.zlib;
  };
}
