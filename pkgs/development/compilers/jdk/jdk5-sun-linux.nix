/**
 * This Nix expression requires the user to download the j2sdk
 * distribution to /tmp. Please obtain jdk-1_5_0_14-linux-i586.bin
 * from java.sun.com by hand and place it in /tmp. Blame Sun, not me.
 *
 * Note that this is not necessary if someone has already pushed a
 * binary.
 */
{stdenv, fetchurl, unzip}: 

assert stdenv.system == "i686-linux";

stdenv.mkDerivation {
  name = "jdk-1.5.0_14";
  filename = "jdk-1_5_0_14";
  dirname = "jdk1.5.0_14";
  builder = ./builder.sh;
  pathname = "/tmp/jdk-1_5_0_14-linux-i586.bin";
  md5 = "32df8f2be09c3a0f39da1b3869164b55";
  stdenv = stdenv;

  inherit unzip;
}
