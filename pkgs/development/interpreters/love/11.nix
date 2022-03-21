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
    sha256 = "0kpdp6v8m8j0r7ppyy067shr0lfgrlh0dwb7ccws76d389vizwhb";
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
