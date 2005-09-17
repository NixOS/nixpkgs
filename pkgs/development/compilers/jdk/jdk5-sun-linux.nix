/**
 * This Nix expression requires the user to download the jdk
 * distribution to /tmp. Please obtain jdk-1_5_0_05-linux-i586.bin
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
  name = "jdk-1.5.0";
  filename = "jdk-1_5_0_05";
  dirname = "jdk1.5.0_05";
  system = stdenv.system;
  builder = ./builder.sh;
  pathname = "/tmp/jdk-1_5_0_05-linux-i586.bin";
  md5 = "2f83bf2a38fff1f8ac51b02ec7391ca3";
  stdenv = stdenv;
}
