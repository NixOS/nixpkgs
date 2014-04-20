{ stdenv, fetchurl, mcpp, bzip2, expat, openssl, db5 }:

stdenv.mkDerivation rec {
  name = "zeroc-ice-3.5.1";

  src = fetchurl {
    url = "http://www.zeroc.com/download/Ice/3.5/Ice-3.5.1.tar.gz";
    sha256 = "14pk794p0fq3hcp50xmqnf9pp15dggiqhcnsav8xpnka9hcm37lq";
  };

  buildInputs = [ mcpp bzip2 expat openssl db5 ];

  buildPhase = ''
    cd cpp
    make OPTIMIZE=yes
  '';

  installPhase = ''
    make prefix=$out install
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.zeroc.com/ice.html";
    description = "The internet communications engine";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
