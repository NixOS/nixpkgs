{ stdenv, fetchurl, readline, nspr }:

stdenv.mkDerivation rec {
  version = "1.8.0-rc1";
  name = "spidermonkey-${version}";

  src = fetchurl {
    url = "mirror://mozilla/js/js-${version}.tar.gz";
    sha256 = "374398699ac3fd802d98d642486cf6b0edc082a119c9c9c499945a0bc73e3413";
  };

  buildInputs = [ readline nspr ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  hardeningDisable = [ "format" ] ++ stdenv.lib.optional stdenv.isi686 "pic";

  makefileExtra = ./Makefile.extra;
  makefile = "Makefile.ref";

  patchPhase =
    ''
      cat ${makefileExtra} >> ${makefile}
      sed -e 's/ -ltermcap/ -lncurses/' -i ${makefile}
    '';

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${nspr.dev}/include/nspr"
  '';

  makeFlags = "-f ${makefile} JS_DIST=\${out} BUILD_OPT=1 JS_READLINE=1 JS_THREADSAFE=1";

  meta = {
    platforms = stdenv.lib.platforms.linux;
  };
}
