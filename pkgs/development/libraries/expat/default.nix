{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "expat-2.0.1";
  
  src = fetchurl {
    url = mirror://sourceforge/expat/expat-2.0.1.tar.gz;
    sha256 = "14sy5qx9hgjyfs743iq8ywldhp5w4n6cscqf2p4hgrw6vys60xl4";
  };

  patches = [ ./cve-2009-3560.patch ];

  meta = {
    homepage = http://expat.sourceforge.net/;
    description = "A stream-oriented XML parser library written in C";
  };
}
