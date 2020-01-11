{ stdenv, fetchurl, pkgconfig
, SDL, libGLU, libGL, openal, lua
, libdevil, freetype, physfs
, libmodplug, mpg123, libvorbis, libogg
}:

stdenv.mkDerivation rec {
  pname = "love";
  version = "0.8.0";

  src = fetchurl {
    url = "https://bitbucket.org/rude/love/downloads/${pname}-${version}-linux-src.tar.gz";
    sha256 = "1k4fcsa8zzi04ja179bmj24hvqcbm3icfvrvrzyz2gw9qwfclrwi";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    SDL libGLU libGL openal lua
    libdevil freetype physfs libmodplug mpg123 libvorbis libogg
  ];

  preConfigure = ''
    luaoptions="${"''"} lua luajit "
    for i in lua luajit-; do
      for j in 5 5.0 5.1 5.2 5.3 5.4; do
        luaoptions="$luaoptions $i$j "
      done
    done
    luaso="$(echo "${lua}/lib/"lib*.so.*)"
    luaso="''${luaso##*/lib}"
    luaso="''${luaso%%.so*}"
    luaoptions="$luaoptions $luaso"
    sed -e "s/${"''"} lua lua.*;/$luaoptions;/" -i configure

    luaincdir="$(echo "${lua}/include"/*/ )"
    test -d "$luaincdir" && {
      export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I$luaincdir"
    } || true
  '';

  NIX_CFLAGS_COMPILE = toString [
    "-I${SDL.dev}/include/SDL"
    "-I${freetype.dev}include/freetype2"
    "-DGL_GLEXT_PROTOTYPES" # https://community.khronos.org/t/glgenbuffers-was-not-declared-in-this-scope/59283/2
  ];

  meta = {
    homepage = "http://love2d.org";
    description = "A Lua-based 2D game engine/scripting language";
    license = stdenv.lib.licenses.zlib;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.raskin ];
  };
}
