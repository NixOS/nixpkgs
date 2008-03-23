args: with args;
stdenv.mkDerivation {
  name = "libixp_for_wmii";
  phases = "unpackPhase installPhase";
  installPhase = "

     export LDFLAGS\=$(echo \$NIX_LDFLAGS | sed -e 's/-rpath/-L/g')
     sed -i -e \"s%^PREFIX.*%PREFIX=\$out%\" \\
            -e \"s%^\\(INCLUDE.*\\)%\\1 \$NIX_CFLAGS_COMPILE%\" \\
            -e \"s%^\\(LIBS.*\\)%\\1 \$LDFLAGS%\" \\
            config.mk
     make install
  ";
  src = fetchurl {
    url = http://www.suckless.org/snaps/libixp-20070220.tar.gz;
    sha256 = "0bhqgrxp0lnwyf3c9165nldyw300mifyh0mlyfg1i5qr54rk7p79";
  };
}
