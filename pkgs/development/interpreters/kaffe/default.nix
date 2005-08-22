{stdenv, fetchurl, alsaLib, xlibs, jikes}:

stdenv.mkDerivation {
  name = "kaffe-1.1.4";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/kaffe-1.1.4.tar.gz;
    md5 = "94d6e7035ba68c2221dce68bb5b3f6e9";
  };
  inherit jikes alsaLib;
  inherit (xlibs) libXaw libX11;

  buildInputs = [jikes alsaLib xlibs.libXaw xlibs.libX11];
}
