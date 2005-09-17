/**
 * This Nix expression requires the user to download the j2sdk
 * distribution to /tmp. Please obtain j2sdk-1_4_2_03-linux-i586.bin
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
  name = "j2sdk-1.4.2";
  filename = "j2sdk-1.4.2_05";
  dirname = "j2sdk1.4.2_05";
  system = stdenv.system;
  builder = ./builder.sh;
  pathname = "/tmp/j2sdk-1_4_2_05-linux-i586.bin";
  md5 = "825ff134f3e370f6e677638d32962082";
  stdenv = stdenv;
}
