{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "olm-${version}";
  version = "2.3.0";

  meta = {
    description = "Implements double cryptographic ratchet and Megolm ratchet";
    license = stdenv.lib.licenses.asl20;
    homepage = https://matrix.org/git/olm/about;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "https://matrix.org/git/olm/snapshot/${name}.tar.gz";
    sha256 = "1y2yasq94zjw3nadn1915j85xwc5j3pic3brhp0h83l6hkxi8dsk";
  };

  doCheck = true;
  checkTarget = "test";

  # requires optimisation but memory operations are compiled with -O0
  hardeningDisable = ["fortify"];

  installFlags = "PREFIX=$(out)";
}
