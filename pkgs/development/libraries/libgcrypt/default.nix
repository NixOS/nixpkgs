{ fetchurl, stdenv, libgpgerror }:

stdenv.mkDerivation rec {
  name = "libgcrypt-1.4.6";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "11bbpjlqwp0nh4q76wmsk6z1812anqrj28nh6d9mcyrmdgd30jry";
  };

  propagatedBuildInputs = [ libgpgerror ];

  doCheck = true;

  # For some reason the tests don't find `libgpg-error.so'.
  checkPhase = ''
    LD_LIBRARY_PATH="${libgpgerror}/lib:$LD_LIBRARY_PATH" \
    make check
  '';

  meta = {
    description = "GNU Libgcrypt, a general-pupose cryptographic library";

    longDescription = ''
      GNU Libgcrypt is a general purpose cryptographic library based on
      the code from GnuPG.  It provides functions for all
      cryptographic building blocks: symmetric ciphers, hash
      algorithms, MACs, public key algorithms, large integer
      functions, random numbers and a lot of supporting functions.
    '';

    license = "LGPLv2+";

    homepage = http://gnupg.org/;
  };
}
