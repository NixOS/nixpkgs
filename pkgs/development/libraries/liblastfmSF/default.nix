{ lib, stdenv, fetchurl, pkg-config, curl, openssl }:

stdenv.mkDerivation {
  name = "liblastfm-SF-0.5";

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ curl openssl ];

  src = fetchurl {
    url = "mirror://sourceforge/liblastfm/libclastfm-0.5.tar.gz";
    sha256 = "0hpfflvfx6r4vvsbvdc564gkby8kr07p8ma7hgpxiy2pnlbpian9";
  };

  meta = {
    homepage = "http://liblastfm.sourceforge.net";
    description = "Unofficial C lastfm library";
    license = lib.licenses.gpl3;
  };
}
