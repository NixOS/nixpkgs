source $stdenv/setup

configureFlags="--with-lua=$lua"

MKFLAGS="-w$lua/include/lauxlib.h,$lua/include/luadebug.h,$lua/include/lua.h,$lua/include/lualib.h"

buildPhase() {
  mk timestamps
  mk $MKFLAGS all all.opt
}

installPhase() {
mk $MKFLAGS install install.opt
find $out -name \*.a -exec echo stripping {} \; \
            -exec strip -S {} \; || fail
patchELF $out
}

buildPhase=buildPhase
installPhase=installPhase

genericBuild
