{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "blackdown-1.4.2";
  dirname = "j2sdk1.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://ftp.nluug.nl/pub/os/Linux/java/jdk/JDK-1.4.2/i386/rc1/j2sdk-1.4.2-rc1-linux-i586-gcc3.2.bin;
    md5 = "52ff3a059845ee8487faeaa7b0c157c8";
  };
}
