{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "coredumper-1.1";
  src = fetchurl {
    url = http://google-coredumper.googlecode.com/files/coredumper-1.1.tar.gz;
    sha256 = "1phl1zg2n17rp595dyzz9iw01gfdpsdh0l6wy2hfb5shi71h63rx";
  };
}
