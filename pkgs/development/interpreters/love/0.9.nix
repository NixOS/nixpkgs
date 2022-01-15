{ lib, stdenv, fetchurl, pkg-config
, SDL2, libGLU, libGL, openal, luajit
, libdevil, freetype, physfs
, libmodplug, mpg123, libvorbis, libogg
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "0.9.2";

  src = fetchurl {
    url = "https://github.com/love2d/love/releases/download/${version}/love-${version}-linux-src.tar.gz";
    sha256 = "0wn1npr5gal5b1idh4a5fwc3f5c36lsbjd4r4d699rqlviid15d9";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    SDL2 libGLU libGL openal luajit
    libdevil freetype physfs libmodplug mpg123 libvorbis libogg
  ];

  configureFlags = [
    "--with-lua=luajit"
  ];

  NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3

  meta = {
    homepage = "https://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = lib.licenses.zlib;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.raskin ];
    broken = true;
  };
}
