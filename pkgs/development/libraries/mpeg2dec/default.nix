{stdenv, fetchurl}: stdenv.mkDerivation {
  name = "mpeg2dec-20030612";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://libmpeg2.sourceforge.net/files/mpeg2dec-0.4.0.tar.gz;
    md5 = "49a70fef1b0f710ed7e64ed32ee82d4d";
  };
}
