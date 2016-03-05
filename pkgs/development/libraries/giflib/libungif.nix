{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "libungif-4.1.4";
  src = fetchurl {
    url = mirror://sourceforge/giflib/libungif-4.1.4.tar.gz;
    md5 = "efdfcf8e32e35740288a8c5625a70ccb";
  };

  hardeningDisable = [ "format" ];
}

