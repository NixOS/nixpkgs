{ fetchurl, stdenv, libgpgerror }:

stdenv.mkDerivation (rec {
  name = "libgcrypt-1.6.0";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "024plbybsmnxbp39hs92lp6dzvkz2cb70nv69qrwr55d02350bb6";
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
    platforms = stdenv.lib.platforms.all;
  };
} # old "as" problem, see #616 and http://gnupg.10057.n7.nabble.com/Fail-to-build-on-freebsd-7-3-td30245.html
  // stdenv.lib.optionalAttrs (stdenv.isFreeBSD && stdenv.isi686)
    { configureFlags = [ "--disable-aesni-support" ]; }
)

