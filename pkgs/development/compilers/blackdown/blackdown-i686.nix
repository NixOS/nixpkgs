{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "blackdown-1.4.2";
  dirname = "j2sdk1.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = ftp://sunsite.dk/mirrors/java-linux/JDK-1.4.2/i386/02/j2sdk-1.4.2-02-linux-i586.bin;
    md5 = "a65733528562794b7838407084cabd9a";
  };
}) // {mozillaPlugin = "/jre/plugin/i386/mozilla";}
