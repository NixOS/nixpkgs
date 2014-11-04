{ fetchurl, stdenv, libgpgerror }:

stdenv.mkDerivation (rec {
  name = "libgcrypt-1.5.4";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "d5f88d9f41a46953dc250cdb8575129b37ee2208401b7fa338c897f667c7fb33";
  };

  propagatedBuildInputs = [ libgpgerror ];

  configureFlags = stdenv.lib.optional stdenv.isDarwin "--disable-asm";

  doCheck = stdenv.system != "i686-linux"; # "basic" test fails after stdenv+glibc-2.18

  # For some reason the tests don't find `libgpg-error.so'.
  checkPhase = ''
    LD_LIBRARY_PATH="${libgpgerror}/lib:$LD_LIBRARY_PATH" \
    make check
  '';

  patches = [ ./no-build-timestamp.patch ];

  meta = {
    description = "General-pupose cryptographic library";

    longDescription = ''
      GNU Libgcrypt is a general purpose cryptographic library based on
      the code from GnuPG.  It provides functions for all
      cryptographic building blocks: symmetric ciphers, hash
      algorithms, MACs, public key algorithms, large integer
      functions, random numbers and a lot of supporting functions.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;

    homepage = http://gnupg.org/;
    platforms = stdenv.lib.platforms.all;
  };
} # old "as" problem, see #616 and http://gnupg.10057.n7.nabble.com/Fail-to-build-on-freebsd-7-3-td30245.html
  // stdenv.lib.optionalAttrs (stdenv.isFreeBSD && stdenv.isi686)
    { configureFlags = [ "--disable-aesni-support" ]; }
)
