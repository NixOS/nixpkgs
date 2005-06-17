{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xproto-6.6.2";
  src = fetchurl {
    url = http://xlibs.freedesktop.org/release/xproto-6.6.2.tar.bz2;
    md5 = "fc419f3028cc2959b979a7e7464105f9";
  };
}
