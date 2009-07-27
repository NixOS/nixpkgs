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

let name = "jdk-1_5_0_19"; in
stdenv.mkDerivation {
  inherit name;
  filename = "jdk-1_5_0_19";
  dirname = "jdk1.5.0_19";
  builder = ./builder.sh;
  pathname = if stdenv.system == "x86_64-linux" then "/tmp/${name}-linux-amd64.bin" else "/tmp/${name}-linux-i586.bin";
  md5 = if stdenv.system == "x86_64-linux" then "28095941e14669d5025f66260e7b61e7" else "0d082a0c9f5a79b0895b3317c9590ec5";
  
  stdenv = stdenv;
  inherit unzip;
}
