{ lib, stdenv, fetchurl, pkg-config, curl, openssl }:

stdenv.mkDerivation rec {
  pname = "liblastfm-SF";
  version = "0.5";

  nativeBuildInputs = [ pkg-config ];

  propagatedBuildInputs = [ curl openssl ];

  src = fetchurl {
    url = "mirror://sourceforge/liblastfm/libclastfm-${version}.tar.gz";
    sha256 = "0hpfflvfx6r4vvsbvdc564gkby8kr07p8ma7hgpxiy2pnlbpian9";
  };

  meta = {
    homepage = "https://liblastfm.sourceforge.net";
    description = "Unofficial C lastfm library";
    license = lib.licenses.gpl3;
  };
}
