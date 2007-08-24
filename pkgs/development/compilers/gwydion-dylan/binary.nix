{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "binary-gwydion-dylan-2.4.0";
  builder = ./binary-builder.sh;
  src = fetchurl {
    url = http://www.gwydiondylan.org/downloads/binaries/linux/x86/tar/gwydion-dylan-2.4.0-x86-linux.tar.gz;
    md5 = "52643ad51a455d21fd4d5bf82d98914c";
  };
}
