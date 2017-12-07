{ stdenv, fetchFromBitbucket, pkgconfig, SDL2, mesa, openal, luajit,
  libdevil, freetype, physfs, libmodplug, mpg123, libvorbis, libogg,
  libtheora, which, autoconf, automake, libtool
}:

let
  pname = "love";
  version = "0.10.2";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromBitbucket {
    owner = "rude";
    repo = "love";
    rev = "${version}";
    sha256 = "19yfmlcx6w8yi4ndm5lni8lrsvnn77bxw5py0dc293nzzlaqa9ym";
  };

  buildInputs = [
    pkgconfig SDL2 mesa openal luajit libdevil freetype physfs libmodplug mpg123
    libvorbis libogg libtheora autoconf which libtool automake
  ];

  preConfigure = "$shell ./platform/unix/automagic";

  configureFlags = [
    "--with-lua=luajit"
  ];

  NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3

  meta = {
    homepage = http://love2d.org;
    description = "A Lua-based 2D game engine/scripting language";
    license = stdenv.lib.licenses.zlib;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
