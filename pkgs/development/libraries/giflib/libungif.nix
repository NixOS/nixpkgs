{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libungif-4.1.4";
  src = fetchurl {
    url = mirror://sourceforge/giflib/libungif-4.1.4.tar.gz;
    sha256 = "5e65e1e5deacd0cde489900dbf54c6c2ee2ebc818199e720dbad685d87abda3d";
  };
}

