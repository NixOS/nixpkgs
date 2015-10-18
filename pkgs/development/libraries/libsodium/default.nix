{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "libsodium-1.0.6";

  src = fetchurl {
    url = "https://download.libsodium.org/libsodium/releases/${name}.tar.gz";
    sha256 = "0ngvcjwg6m9nivzi208yvz8yvmk6kxnvyr25w907kaicgpm063cl";
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
