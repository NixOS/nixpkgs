/**
 * This Nix expression requires the user to download the j2sdk
 * distribution to /tmp. Please obtain j2sdk-1_5_0-beta-linux-i586.bin
 * from java.sun.com by hand and place it in /tmp. Blame Sun, not me.
 *
 * Note that this is not necessary if someone has already pushed a
 * binary.
 *
 * @author Martin Bravenboer <martin@cs.uu.nl>
 */
{stdenv, fetchurl}: 

assert stdenv.system == "i686-linux";

derivation {
  name = "j2sdk-1.5.0";
  filename = "jdk-1_5_0";
  dirname = "jdk1.5.0";
  system = stdenv.system;
  builder = ./builder.sh;
  pathname = "/tmp/jdk-1_5_0-linux-i586.bin";
  md5 = "81d0511feb32e7b7d61f7c07ee0b15e9";
  stdenv = stdenv;
}
