{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "jbigkit-2.1";

  src = fetchurl {
    url = "http://www.cl.cam.ac.uk/~mgk25/jbigkit/download/${name}.tar.gz";
    sha256 = "0cnrcdr1dwp7h7m0a56qw09bv08krb37mpf7cml5sjdgpyv0cwfy";
  };

  postPatch = ''
    sed -i 's/^\(CFLAGS.*\)$/\1 -fPIC/' Makefile
  '' + stdenv.lib.optionalString stdenv.cc.isClang ''
    substituteInPlace Makefile libjbig/Makefile pbmtools/Makefile \
      --replace "CC = gcc" "CC = clang"
  '';

  installPhase = ''
    install -D -m644 libjbig/libjbig.a $out/lib/libjbig.a
    install -D -m644 libjbig/libjbig85.a $out/lib/libjbig85.a
    install -D -m644 libjbig/jbig.h $out/include/jbig.h
    install -D -m644 libjbig/jbig_ar.h $out/include/jbig_ar.h
    install -D -m644 libjbig/jbig85.h $out/include/jbig85.h

    install -d -m755 $out/share/man/man1
    install -m644 pbmtools/*.1* $out/share/man/man1

    install -D -m755 pbmtools/jbgtopbm $out/bin/jbgtopbm
    install -D -m755 pbmtools/pbmtojbg $out/bin/pbmtojbg
    install -D -m755 pbmtools/jbgtopbm85 $out/bin/jbgtopbm85
    install -D -m755 pbmtools/pbmtojbg85 $out/bin/pbmtojbg85
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.cl.cam.ac.uk/~mgk25/jbigkit/";
    description = "A software implementation of the JBIG1 data compression standard";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
