{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "xproto-6.6.2";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/xproto-6.6.2.tar.bz2;
    md5 = "fc419f3028cc2959b979a7e7464105f9";
  };
}
