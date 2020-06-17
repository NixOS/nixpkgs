{ stdenv, fetchurl, bigloo }:

stdenv.mkDerivation rec {
  name = "hop-2.5.1";
  src = fetchurl {
    url = "ftp://ftp-sop.inria.fr/indes/fp/Hop/${name}.tar.gz";
    sha256 = "1bvp7pc71bln5yvfj87s8750c6l53wjl6f8m12v62q9926adhwys";
  };

  buildInputs = [ bigloo ];

  preConfigure = ''
    export NIX_LDFLAGS="$NIX_LDFLAGS -lbigloogc-4.1a";
  '';

  configureFlags = [
    "--bigloo=${bigloo}/bin/bigloo"
    "--bigloolibdir=${bigloo}/lib/bigloo/4.1a/"
  ];

  meta = with stdenv.lib; {
    description = "A multi-tier programming language for the Web 2.0 and the so-called diffuse Web";
    homepage = "http://hop.inria.fr/";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ vbgl ];
  };
}
