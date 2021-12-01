{ lib, stdenv, fetchFromBitbucket, pkg-config, SDL2, libGLU, libGL, openal, luajit,
  libdevil, freetype, physfs, libmodplug, mpg123, libvorbis, libogg,
  libtheora, which, autoconf, automake, libtool
}:

let
  pname = "love";
  version = "11.3";
in

stdenv.mkDerivation {
  name = "${pname}-${version}";
  src = fetchFromBitbucket {
    owner = "rude";
    repo = "love";
    rev = version;
    sha256 = "18gfp65ngb8k8g7hgbw2bhrwk2i7m56m21d39pk4484q9z8p4vm7";
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
    homepage = "http://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.raskin ];
  };
}
