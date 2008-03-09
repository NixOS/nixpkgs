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

let name = "jdk-1_5_0_15"; in
stdenv.mkDerivation {
  inherit name;
  filename = "jdk-1_5_0_15";
  dirname = "jdk1.5.0_15";
  builder = ./builder.sh;
  pathname = if stdenv.system == "x86_64-linux" then "/tmp/${name}-linux-amd64.bin" else "/tmp/${name}-linux-i586.bin";
  md5 = if stdenv.system == "x86_64-linux" then "8c560eda470a50926b9e8dab2c806a25" else "6f45ac598a2f6ff73a2429d6a0da2624";
  
  stdenv = stdenv;
  inherit unzip;
}
