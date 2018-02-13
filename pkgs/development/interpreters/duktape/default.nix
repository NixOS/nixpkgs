{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "duktape-${version}";
  version = "2.2.0";
  src = fetchurl {
    url = "http://duktape.org/duktape-${version}.tar.xz";
    sha256 = "050csp065ll67dck94s0vdad5r5ck4jwsz1fn1y0fcvn88325xv2";
  };

  buildPhase = ''
    make -f Makefile.sharedlibrary
    make -f Makefile.cmdline
  '';
  installPhase = ''
    install -d $out/bin
    install -m755 duk $out/bin/
    install -d $out/lib
    install -m755 libduktape* $out/lib/
  '';
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An embeddable Javascript engine, with a focus on portability and compact footprint";
    homepage = "http://duktape.org/";
    downloadPage = "http://duktape.org/download.html";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
}
