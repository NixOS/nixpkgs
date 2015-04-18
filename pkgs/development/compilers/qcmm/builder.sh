source $stdenv/setup

configureFlags="--with-lua=$lua"

MKFLAGS="-w$lua/include/lauxlib.h,$lua/include/luadebug.h,$lua/include/lua.h,$lua/include/lualib.h"

buildPhase() {
  mk timestamps
  mk $MKFLAGS all.opt
}

installPhase() {
  mk $MKFLAGS install.opt

  for file in $out/bin/*.opt; do
    mv $file ${file%.opt}
  done

  find $out/man -type f -exec gzip -9n {} \;

  find $out -name \*.a -exec echo stripping {} \; \
            -exec strip -S {} \;

  patchELF $out
}

checkPhase="mk $MKFLAGS test.opt"

genericBuild
