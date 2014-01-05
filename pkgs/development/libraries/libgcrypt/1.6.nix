{ fetchurl, stdenv, libgpgerror, transfig, ghostscript, texinfo }:

stdenv.mkDerivation rec {
  name = "libgcrypt-1.6.0";

  src = fetchurl {
    url = "mirror://gnupg/libgcrypt/${name}.tar.bz2";
    sha256 = "024plbybsmnxbp39hs92lp6dzvkz2cb70nv69qrwr55d02350bb6";
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

    homepage = https://www.gnu.org/software/libgcrypt/;
    repositories.git = git://git.gnupg.org/libgcrypt.git;
    platforms = stdenv.lib.platforms.all;
  };
}
