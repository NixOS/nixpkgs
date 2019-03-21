{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "duktape-${version}";
  version = "2.3.0";
  src = fetchurl {
    url = "http://duktape.org/duktape-${version}.tar.xz";
    sha256 = "1s5g8lg0dga6x3rcq328a6hsd2sk2vzwq9zfmskjh5h6n8x2yvpd";
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
