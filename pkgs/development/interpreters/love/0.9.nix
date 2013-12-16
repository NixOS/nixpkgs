{ stdenv, fetchurl, pkgconfig
, SDL2, mesa, openal, luajit
, libdevil, freetype, physfs
, libmodplug, mpg123, libvorbis, libogg
}:

stdenv.mkDerivation rec {
  name = "love-0.9.0";
  src = fetchurl {
    url = "https://bitbucket.org/rude/love/downloads/${name}-linux-src.tar.gz";
    sha256 = "048n94584cnmdaf2rshakdzbj1lz2yd7k08aiykkpz13aaa283ag";
  };

  buildInputs = [
    pkgconfig SDL2 mesa openal luajit
    libdevil freetype physfs libmodplug mpg123 libvorbis libogg
  ];

  configureFlags = [
    "--with-lua=luajit"
  ];

  meta = {
    homepage = "http://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = "zlib";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
