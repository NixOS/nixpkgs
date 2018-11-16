{ stdenv, fetchFromBitbucket, pkgconfig, SDL2, libGLU_combined, openal, luajit,
  libdevil, freetype, physfs, libmodplug, mpg123, libvorbis, libogg,
  libtheora, which, autoconf, automake, libtool
}:

let
  pname = "love";
  version = "11.1";
in

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  src = fetchFromBitbucket {
    owner = "rude";
    repo = "love";
    rev = "${version}";
    sha256 = "16jn6klbsz8qi2wn3llbr7ri5arlc0b19la19ypzk6p7v20z4sfr";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    SDL2 libGLU_combined openal luajit libdevil freetype physfs libmodplug mpg123
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
