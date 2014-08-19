{ fetchurl, stdenv, libgpgerror, transfig, ghostscript, texinfo }:

stdenv.mkDerivation rec {
  name = "libgcrypt-1.6.1";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "0w10vhpj1r5nq7qm6jp21p1v1vhf37701cw8yilygzzqd7mfzhx1";
  };

  nativeBuildInputs = [ transfig ghostscript texinfo ];

  propagatedBuildInputs = [ libgpgerror ];

  preBuild = ''
    (cd doc; make stamp-vti)
  '';

  doCheck = true;

  # For some reason the tests don't find `libgpg-error.so'.
  checkPhase = ''
    LD_LIBRARY_PATH="${libgpgerror}/lib:$LD_LIBRARY_PATH" \
    make check
  '';

  crossAttrs = let
    isCross64 = stdenv.cross.config == "x86_64-w64-mingw32";
  in stdenv.lib.optionalAttrs isCross64 {
    configureFlags = [ "--disable-asm" "--disable-padlock-support" ];
  };

  meta = {
    description = "GNU Libgcrypt, a general-pupose cryptographic library";

    longDescription = ''
      GNU Libgcrypt is a general purpose cryptographic library based on
      the code from GnuPG.  It provides functions for all
      cryptographic building blocks: symmetric ciphers, hash
      algorithms, MACs, public key algorithms, large integer
      functions, random numbers and a lot of supporting functions.
    '';

    license = stdenv.lib.licenses.lgpl2Plus;

    homepage = https://www.gnu.org/software/libgcrypt/;
    repositories.git = git://git.gnupg.org/libgcrypt.git;
    platforms = stdenv.lib.platforms.all;
  };
}
