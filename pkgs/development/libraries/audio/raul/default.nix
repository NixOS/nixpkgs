{ stdenv, fetchsvn, boost, gtk2, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "raul-svn-${rev}";
  rev = "5675";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/raul";
    rev = rev;
    sha256 = "0yvm3j57lch89dixx7zsip7pxsws0xxy1y6ck7a3l0534qc5kny4";
  };

  buildInputs = [ boost gtk2 pkgconfig python ];

  configurePhase = "python waf configure --prefix=$out";

  buildPhase = "python waf";

  installPhase = "python waf install";

  meta = with stdenv.lib; {
    description = "A C++ utility library primarily aimed at audio/musical applications";
    homepage = http://drobilla.net/software/raul;
    license = licenses.gpl3;
    maintainers = [ maintainers.goibhniu ];
    platforms = platforms.linux;
  };
}
