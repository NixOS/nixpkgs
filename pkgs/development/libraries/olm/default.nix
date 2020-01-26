{ stdenv, fetchurl, cmake }:

stdenv.mkDerivation rec {
  pname = "olm";
  version = "3.1.4";

  src = fetchurl {
    url = "https://matrix.org/git/olm/-/archive/${version}/${pname}-${version}.tar.gz";
    sha256 = "0f7azjxc77n4ib9nj3cwyk3vhk8r2dsyf7id6nvqyxqxwxn95a8w";
  };

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
    platforms = with stdenv.lib.platforms; darwin ++ linux;
  };
}
