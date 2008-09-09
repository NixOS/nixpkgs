{ fetchurl, stdenv, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libgcrypt-1.4.2";

  src = fetchurl {
    url = "ftp://ftp.gnupg.org/gcrypt/libgcrypt/${name}.tar.bz2";
    sha256 = "1hsj26c68lffhz00mi5i70kc5mg9l0dxlf6g48ms4fvzdy218x5s";
  };

  propagatedBuildInputs = [ libgpgerror ];

  doCheck = true;

  # For some reason the tests don't find `libgpg-error.so'.
  checkPhase = ''
    LD_LIBRARY_PATH="${libgpgerror}/lib:$LD_LIBRARY_PATH" \
    make check
  '';

  meta = {
    description = "libgcrypt, a general-pupose cryptographic library";

    longDescription = ''
      Libgcrypt is a general purpose cryptographic library based on
      the code from GnuPG.  It provides functions for all
      cryptographic building blocks: symmetric ciphers, hash
      algorithms, MACs, public key algorithms, large integer
      functions, random numbers and a lot of supporting functions.
    '';

    license = "LGPLv2+";

    homepage = http://gnupg.org/;
  };
}
