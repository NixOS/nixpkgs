{ lib, stdenv, fetchFromGitHub, pkg-config
, SDL2, libGLU, libGL, openal, luajit
, libdevil, freetype, physfs, libmodplug, mpg123, libvorbis, libogg
, libtheora, which, autoconf, automake, libtool
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "11.4";

  src = fetchFromGitHub {
    owner = "love2d";
    repo = "love";
    rev = version;
    sha256 = "sha256-C/Ifd0KjmaM5Y2fxBiDNz1GQoT4GeH/vyUCiira57U4=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2 libGLU libGL openal luajit libdevil freetype physfs libmodplug mpg123
    libvorbis libogg libtheora autoconf which libtool automake
  ];

  preConfigure = "$shell ./platform/unix/automagic";

  configureFlags = [
    "--with-lua=luajit"
  ];

  NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

  meta = {
    homepage = "https://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.raskin ];
  };
}
