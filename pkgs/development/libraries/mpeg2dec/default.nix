{stdenv, fetchurl}: derivation {
  name = "mpeg2dec-20030612";
  system = stdenv.system;
  builder = ./builder.sh;
  src = fetchurl {
    url = http://libmpeg2.sourceforge.net/files/mpeg2dec-0.4.0.tar.gz;
    md5 = "49a70fef1b0f710ed7e64ed32ee82d4d";
  };
  stdenv = stdenv;
}
