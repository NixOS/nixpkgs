{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "duktape";
  version = "2.4.0";
  src = fetchurl {
    url = "http://duktape.org/duktape-${version}.tar.xz";
    sha256 = "1z3i0ymnkk6q48bmbgh59g1ryrwjdv46vrf6nbnmqfv3s43r7a46";
  };

  buildPhase = ''
    make -f Makefile.sharedlibrary
    make -f Makefile.cmdline
  '';
  installPhase = ''
    install -d $out/bin
    install -m755 duk $out/bin/
    install -d $out/lib
    install -d $out/include
    make -f Makefile.sharedlibrary install INSTALL_PREFIX=$out
  '';
  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "An embeddable Javascript engine, with a focus on portability and compact footprint";
    homepage = https://duktape.org/;
    downloadPage = https://duktape.org/download.html;
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
}
