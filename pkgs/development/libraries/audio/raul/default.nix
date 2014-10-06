{ stdenv, fetchsvn, boost, gtk, pkgconfig, python }:

stdenv.mkDerivation rec {
  name = "raul-svn-${rev}";
  rev = "5449";

  src = fetchsvn {
    url = "http://svn.drobilla.net/lad/trunk/raul";
    rev = rev;
    sha256 = "02ph1hikp1iynwbxbiaf28brkwig7n4lsb3djaivnf14arg5vmzx";
  };

  buildInputs = [ boost gtk pkgconfig python ];

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
