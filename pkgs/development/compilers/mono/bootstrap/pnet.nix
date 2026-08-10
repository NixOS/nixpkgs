{
  lib,
  stdenv,
  fetchgit,
  autoreconfHook,
  automake,
  bison,
  flex,
  libatomic_ops,
  libffi,
  libtool,
  boehmgc,
  perl,
  python3,
  texinfo,
  treecc,
  guixPatches,
}:

stdenv.mkDerivation {
  pname = "pnet";
  version = "0.8.0-unstable-2011-06-15";

  src = fetchgit {
    url = "git://git.sv.gnu.org/dotgnu-pnet/pnet.git";
    rev = "3baf94734d8dc3fdabba68a8891e67a43ed6c4bd";
    hash = "sha256-xv4aA7M7/i2DOw6g6zc4xbKTKRu7/BxWvBVQ9F/e9m8=";
  };

  patches = [
    guixPatches."pnet-newer-libgc-fix.patch"
    guixPatches."pnet-newer-texinfo-fix.patch"
    guixPatches."pnet-fix-line-number-info.patch"
    guixPatches."pnet-fix-off-by-one.patch"
  ];

  nativeBuildInputs = [
    autoreconfHook
    automake
    bison
    flex
    libatomic_ops
    libtool
    perl
    python3
    texinfo
    treecc
  ];

  buildInputs = [
    boehmgc
    libffi
  ];

  postPatch = ''
    rm -rf libffi libgc
    rm -f compile configure config.guess config.sub depcomp install-sh ltconfig ltcf-c.sh ltmain.sh
    find . \( -name 'Makefile' -o -name 'Makefile.in' -o -name '_grammar.c' -o -name '_grammar.h' -o -name '_scanner.c' -o -name '_scanner.h' \) -delete

    substituteInPlace configure.in \
      --replace-fail "GCLIBS='\$(top_builddir)/libgc/.libs/libgc.a'" "GCLIBS='-lgc'" \
      --replace-fail "search_libjit=true" $'search_libjit=false\nJIT_LIBS=-ljit'

    substituteInPlace Makefile.am \
      --replace-fail "OPT_SUBDIRS += libffi" "" \
      --replace-fail "OPT_SUBDIRS += libgc" ""
    substituteInPlace support/hb_gc.c \
      --replace-fail '#include "../libgc/include/gc.h"' '#include <gc.h>' \
      --replace-fail '#include "../libgc/include/gc_typed.h"' '#include <gc/gc_typed.h>'
    perl -0pi -e 's/^TREECC_OUTPUT =.*$/TREECC_OUTPUT =/mg' \
      codegen/Makefile.am cscc/bf/Makefile.am cscc/csharp/Makefile.am cscc/c/Makefile.am cscc/java/Makefile.am
    substituteInPlace cscc/csharp/cs_grammar.y --replace-fail YYLEX 'yylex()'
    substituteInPlace cscc/common/cc_main.h \
      --replace-fail 'CCPreProc CCPreProcessorStream;' 'extern CCPreProc CCPreProcessorStream;'
    substituteInPlace csdoc/scanner.c \
      --replace-fail $'int\ttoken;' $'extern int\ttoken;'
    substituteInPlace doc/cvmdoc.py --replace-fail python1.5 python
    substituteInPlace profiles/full --replace-fail 'IL_CONFIG_UNROLL=y' 'IL_CONFIG_UNROLL=n'
  '';

  hardeningDisable = [ "format" ];

  env.CFLAGS = "-O2 -g -Wno-pointer-to-int-cast -Wno-error=implicit-function-declaration -Wno-error=incompatible-pointer-types";

  postInstall = ''
    rm -f "$out/share/man/man1/cli-unknown-ar.1.gz"
  '';

  meta = {
    description = "DotGNU Portable.NET C# compiler and runtime";
    homepage = "http://www.gnu.org/software/dotgnu/html2.0/pnet.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
}
