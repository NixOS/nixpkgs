{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "duktape";
  version = "2.6.0";
  src = fetchurl {
    url = "http://duktape.org/duktape-${version}.tar.xz";
    sha256 = "19szwxzvl2g65fw95ggvb8h0ma5bd9vvnnccn59hwnc4dida1x4n";
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
    homepage = "https://duktape.org/";
    downloadPage = "https://duktape.org/download.html";
    license = licenses.mit;
    maintainers = [ maintainers.fgaz ];
    platforms = platforms.linux;
  };
}
