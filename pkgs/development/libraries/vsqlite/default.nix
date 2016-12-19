{ stdenv, fetchurl, boost, sqlite }:

stdenv.mkDerivation rec {
  name = "vsqlite-${version}";
  version = "0.3.13";

  src = fetchurl {
    url = "http://evilissimo.fedorapeople.org/releases/vsqlite--/0.3.13/vsqlite++-${version}.tar.gz";
    sha256 = "17fkj0d2jh0xkjpcayhs1xvbnh1d69f026i7vs1zqnbiwbkpz237";
  };

  buildInputs = [ boost sqlite ];

  meta = {
    homepage = http://vsqlite.virtuosic-bytes.com/;
    description = "C++ wrapper library for sqlite.";
    license = stdenv.lib.licenses.bsd3;
    platforms = stdenv.lib.platforms.unix;
  };
}
