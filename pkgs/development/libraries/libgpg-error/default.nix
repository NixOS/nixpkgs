{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libgpg-error-1.4";
  src = fetchurl {
    url = ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.4.tar.gz;
    sha256 = "06fn9rshrm7r49fkjc17xg39nz37kyda2l13qqgzjg69zz2pxxpz";
  };
}
