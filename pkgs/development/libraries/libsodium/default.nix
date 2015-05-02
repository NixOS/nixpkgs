{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.2";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "06dabf77cz6qg7aqv5j5r4m32b5zn253pixwb3k5lm3z0h88y7cn";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString (stdenv.cc.cc.isGNU or false) "-lssp";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Version of NaCl with hardware tests at runtime, not build time";
    license = licenses.isc;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = platforms.all;
  };
}
