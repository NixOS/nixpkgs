{ fetchgit, stdenv, libgpgerror, autoconf, automake, libtool, transfig, ghostscript, texinfo }:

stdenv.mkDerivation rec {
  name = "libgcrypt-git-20130524";

  src = fetchgit {
    url = git://git.gnupg.org/libgcrypt.git;
    rev = "99b18aa53";
    sha256 = "1rhbpxqrkfszlv8jvw8s4apwklal07k8zxv5q555l7binc1j1j3z";
  };

  nativeBuildInputs = [ autoconf automake libtool transfig ghostscript texinfo ];

  propagatedBuildInputs = [ libgpgerror ];

  preConfigure = ''
    sh autogen.sh
  '';

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
    platforms = stdenv.lib.platforms.all;
  };
}
