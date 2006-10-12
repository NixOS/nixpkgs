{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "mpeg2dec-20050802";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mpeg2dec-20050802.tar.gz;
    md5 = "79b3559a9354085fcebb1460dd93d237";
  };
}
