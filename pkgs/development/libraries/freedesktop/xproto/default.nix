{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xproto-6.6.1";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://freedesktop.org/~xlibs/release/xlibs-1.0/xproto-6.6.1.tar.bz2;
    md5 = "8a7546a607dcd61b2ee595c763fd7f85";
  };
}
