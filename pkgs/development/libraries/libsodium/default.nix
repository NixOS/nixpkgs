{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.3";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "120jkda2q58p0n68banh64vsfm3hgqnacagj425d218cr4ycdkyb";
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
