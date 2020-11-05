{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.2.1";

  src = fetchurl {
    url = "https://matrix.org/git/olm/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "0iacbi9iibhzifh1bk6bi5xin557lvqmbf4ccsb8drj50dbxjiyr";
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
