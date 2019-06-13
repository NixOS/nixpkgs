{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "olm-${version}";
  version = "3.0.0";

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "https://matrix.org/git/olm/snapshot/${name}.tar.gz";
    sha256 = "1iivxjk458v9lhqgzp0c4k5azligsh9k3rk6irf9ssj29wzgjm2c";
  };

  doCheck = true;
  checkTarget = "test";

  # requires optimisation but memory operations are compiled with -O0
  hardeningDisable = ["fortify"];

  installFlags = "PREFIX=$(out)";
}
