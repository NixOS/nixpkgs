args: with args;

stdenv.mkDerivation {
  name = "libgcrypt-1.3.1";
  src = fetchurl {
    urls = [
      ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.3.1.tar.bz2
      ftp://ftp.gnupg.org/gcrypt/alpha/libgcrypt/libgcrypt-1.3.1.tar.bz2
    ];
    sha256 = "0ip0bjhnn12lvb050j91x64wfhmpk7xlc3p93mxi9g2qczg413nz";
  };

  propagatedBuildInputs = [libgpgerror];
}
