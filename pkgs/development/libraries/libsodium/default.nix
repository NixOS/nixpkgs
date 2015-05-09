{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.3";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "120jkda2q58p0n68banh64vsfm3hgqnacagj425d218cr4ycdkyb";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString (stdenv.cc.cc.isGNU or false) "-lssp";

  doCheck = true;

  meta = {
    description = "Version of NaCl with hardware tests at runtime, not build time";
    license = stdenv.lib.licenses.isc;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}
