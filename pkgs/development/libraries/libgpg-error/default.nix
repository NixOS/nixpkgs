{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "libgpg-error-1.4";
  src = fetchurl {
    url = "mirror://gnupg/libgpg-error/${name}.tar.gz";
    sha256 = "06fn9rshrm7r49fkjc17xg39nz37kyda2l13qqgzjg69zz2pxxpz";
  };
}
