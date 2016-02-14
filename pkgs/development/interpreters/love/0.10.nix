{ stdenv, fetchFromBitbucket, pkgconfig, SDL2, mesa, openal, luajit,
  libdevil, freetype, physfs, libmodplug, mpg123, libvorbis, libogg,
  libtheora, which, autoconf, automake, libtool
}:

let
  pname = "love";
  version = "0.10.1";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromBitbucket {
    owner = "rude";
    repo = "love";
    rev = "${version}";
    sha256 = "10a2kkyx7x9jkcj9xrqgmvp0b6gbapjqjx9fib9f6a0nbz0xaswj";
  };

  buildInputs = [
    pkgconfig SDL2 mesa openal luajit libdevil freetype physfs libmodplug mpg123
    libvorbis libogg libtheora autoconf which libtool automake
  ];

  preConfigure = "$shell ./platform/unix/automagic";

  configureFlags = [
    "--with-lua=luajit"
  ];

  meta = {
    homepage = "http://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
