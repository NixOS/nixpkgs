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
  name = "j2sdk-1.5.0-beta2";
  filename = "jdk-1_5_0-beta2";
  dirname = "jdk1.5.0";
  system = stdenv.system;
  builder = ./builder.sh;
  pathname = "/tmp/jdk-1_5_0-beta2-linux-i586.bin";
  md5 = "93556887af8910d709de028ddb07f27d";
  stdenv = stdenv;
}
