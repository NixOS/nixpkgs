{stdenv, fetchurl}: derivation {
  name = "mpeg2dec-20030612";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://www.videolan.org/pub/videolan/vlc/0.6.2/contrib/mpeg2dec-20030612.tar.bz2;
    md5 = "17b880eb8766a2e46834d2274882d284";
  };
  stdenv = stdenv;
}
