{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.1.5";

  src = fetchurl {
    url = "https://matrix.org/git/olm/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "15l6cf029ghfk5bf8ii6nyy86gc90ji8n5hspjhj1xmzmk61xb4j";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = "https://gitlab.matrix.org/matrix-org/olm";
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };
}
