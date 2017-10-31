{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "olm-${version}";
  version = "2.2.1";

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
  };

  src = fetchurl {
    url = "https://matrix.org/git/olm/snapshot/${name}.tar.gz";
    sha256 = "1spgsjmsw8afm2hg1mrq9c7cli3p17wl0ns7qbzn0h6ksh193709";
  };

  doCheck = true;
  checkTarget = "test";

  installFlags = "PREFIX=$(out)";
}
