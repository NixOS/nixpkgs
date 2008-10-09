/**
 * This Nix expression requires the user to download the j2sdk
 * distribution to /tmp. Please obtain jdk-1_5_0_14-linux-i586.bin
 * from java.sun.com by hand and place it in /tmp. Blame Sun, not me.
 *
 * Note that this is not necessary if someone has already pushed a
 * binary.
 */
{stdenv, fetchurl, unzip}: 

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let name = "jdk-1_5_0_16"; in
stdenv.mkDerivation {
  inherit name;
  filename = "jdk-1_5_0_16";
  dirname = "jdk1.5.0_16";
  builder = ./builder.sh;
  pathname = if stdenv.system == "x86_64-linux" then "/tmp/${name}-linux-amd64.bin" else "/tmp/${name}-linux-i586.bin";
  md5 = if stdenv.system == "x86_64-linux" then "ca0fb55426615512d00e7d3cb26442bb" else "ac4ad1c563bfa7fea88f08be08cdee10";
  
  stdenv = stdenv;
  inherit unzip;
}
