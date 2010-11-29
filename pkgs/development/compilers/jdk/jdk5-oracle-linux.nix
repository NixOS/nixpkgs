/**
 * This Nix expression requires the user to download the Java 5.0 JDK
 * distribution to /tmp. Please obtain jdk-1_5_0_22-linux-i586.bin for
 * 32-bit systems or jdk-1_5_0_22-linux-amd64.bin for 64-bit systems
 * from java.sun.com (look for archived software downloads) 
 * by hand and place it in /tmp. Blame Oracle, not me.
 *
 * Note that this is not necessary if someone has already pushed a
 * binary.
 */
{stdenv, fetchurl, unzip}: 

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

let name = "jdk-1_5_0_22"; in
stdenv.mkDerivation {
  inherit name;
  filename = "jdk-1_5_0_22";
  dirname = "jdk1.5.0_22";
  builder = ./builder.sh;
  pathname = if stdenv.system == "x86_64-linux" then "/tmp/${name}-linux-amd64.bin" else "/tmp/${name}-linux-i586.bin";
  md5 = if stdenv.system == "x86_64-linux" then "b62abcaf9ea8617c50fa213bbc88824a" else "df5dae6d50d2abeafb472dde6d9a17f3";
  
  stdenv = stdenv;
  inherit unzip;
}
