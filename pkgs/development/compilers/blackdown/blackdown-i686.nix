{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

(stdenv.mkDerivation {
  name = "blackdown-1.4.2";
  dirname = "j2sdk1.4.2";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/j2sdk-1.4.2-02-linux-i586.bin;
    md5 = "a65733528562794b7838407084cabd9a";
  };
}) // {mozillaPlugin = "/jre/plugin/i386/mozilla";}
