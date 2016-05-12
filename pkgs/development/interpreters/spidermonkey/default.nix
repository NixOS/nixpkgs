{ stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  name = "spidermonkey-1.7";

  src = fetchurl {
    url = mirror://mozilla/js/js-1.7.0.tar.gz;
    sha256 = "12v6v2ccw1y6ng3kny3xw0lfs58d1klylqq707k0x04m707kydj4";
  };

  buildInputs = [ readline ];

  postUnpack = "sourceRoot=\${sourceRoot}/src";

  makefileExtra = ./Makefile.extra;
  makefile = "Makefile.ref";

  patchPhase =
    ''
      cat ${makefileExtra} >> ${makefile}
      sed -e 's/ -ltermcap/ -lncurses/' -i ${makefile}
    '';

  CFLAGS = "-DPIC -fPIC -DJS_C_STRINGS_ARE_UTF8";

  makeFlags = "-f ${makefile} JS_DIST=\${out} BUILD_OPT=1 JS_READLINE=1";

  meta = with stdenv.lib; {
    description = "Mozilla's JavaScript engine written in C/C++";
    homepage = "https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey";
    license = licenses.mpl20;
    platforms = platforms.all;
  };
}
