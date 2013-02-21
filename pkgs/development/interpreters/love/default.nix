{ stdenv, fetchurl, pkgconfig
, SDL, mesa, openal, lua5
, libdevil, freetype, physfs
, libmodplug, mpg123, libvorbis, libogg
}:

stdenv.mkDerivation rec {
  name = "love-0.8.0";
  src = fetchurl {
    url = "https://bitbucket.org/rude/love/downloads/${name}-linux-src.tar.gz";
    sha256 = "1k4fcsa8zzi04ja179bmj24hvqcbm3icfvrvrzyz2gw9qwfclrwi";
  };

  buildInputs = [
    pkgconfig SDL mesa openal lua5
    libdevil freetype physfs libmodplug mpg123 libvorbis libogg
  ];

  NIX_CFLAGS_COMPILE = ''
    -I${SDL}/include/SDL
    -I${freetype}include/freetype2
  '';

  meta = {
    homepage = "http://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = "zlib";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.matainters.raskin ];
  };
}

