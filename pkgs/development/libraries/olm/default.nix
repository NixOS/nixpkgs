{ lib, stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.2";

  src = fetchurl {
    url = "https://matrix.org/git/olm/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "sha256-/vZALryKULsRFuryxN4TrpElXRH/GnzuyoqXpAfjEPQ=";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = lib.licenses.asl20;
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    platforms = with lib.platforms; darwin ++ linux;
  };
}
