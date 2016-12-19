{ stdenv, fetchurl, automake, autoconf, libtool, which }:

stdenv.mkDerivation rec {
  name = "ilmbase-2.2.0";

  src = fetchurl {
    url = "http://download.savannah.nongnu.org/releases/openexr/${name}.tar.gz";
    sha256 = "1izddjwbh1grs8080vmaix72z469qy29wrvkphgmqmcm0sv1by7c";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    ./bootstrap
  '';

  buildInputs = [ automake autoconf libtool which ];

  NIX_CFLAGS_LINK = [ "-pthread" ];

  patches = [ ./bootstrap.patch ];

  meta = with stdenv.lib; {
    homepage = http://www.openexr.com/;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ wkennington ];
  };
}
