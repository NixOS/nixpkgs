{stdenv, fetchurl, visualcpp}:

assert stdenv.system == "i686-cygwin";

stdenv.mkDerivation {
  name = "win32-hello";
  builder = ./builder.sh;
  src = ./hello.c;
  inherit visualcpp;
}
