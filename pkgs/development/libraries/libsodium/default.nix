{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.3";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "120jkda2q58p0n68banh64vsfm3hgqnacagj425d218cr4ycdkyb";
  };

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.cc.isGNU "-lssp";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "A modern and easy-to-use crypto library";
    homepage = http://doc.libsodium.org/;
    license = licenses.isc;
    maintainers = with maintainers; [ raskin viric wkennington ];
    platforms = platforms.all;
  };
}
