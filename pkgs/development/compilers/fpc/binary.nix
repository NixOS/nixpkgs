{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "fpc-2.4.0-binary";

  src =
    if stdenv.system == "i686-linux" then
      fetchurl {
        url = "ftp://ftp.chg.ru/pub/lang/pascal/fpc/dist/2.4.0/i386-linux/fpc-2.4.0.i386-linux.tar";
        sha256 = "1zas9kp0b36zxqvb9i4idh2l0nb6qpmgah038l77w6las7ghh0dv";
      }
    else if stdenv.system == "x86_64-linux" then
      fetchurl {
        url = "ftp://ftp.chg.ru/pub/lang/pascal/fpc/dist/2.4.0/x86_64-linux/fpc-2.4.0.x86_64-linux.tar";
        sha256 = "111d11g5ra55hjywx64ldwwflpimsy8zryvap68v0309nyd23f0z";
      }
    else throw "Not supported on ${stdenv.system}.";

  builder = ./binary-builder.sh;

  meta = {
    description = "Free Pascal Compiler from a binary distribution";
  };
} 
