/**
 * This Nix expression requires the user to download the jdk
 * distribution to /tmp. Please obtain jdk-1_5_0_06-linux-i586.bin
 * from java.sun.com by hand and place it in /tmp. Blame Sun, not me.
 *
 * Note that this is not necessary if someone has already pushed a
 * binary.
 *
 * @author Martin Bravenboer <martin@cs.uu.nl>
 */
{ swingSupport ? true
, stdenv, fetchurl, unzip, libX11 ? null, libXext ? null
}:

assert stdenv.system == "i686-linux";

assert swingSupport -> libX11 != null && libXext != null;

(stdenv.mkDerivation {
  name = "jdk-1.5.0";
  builder = ./builder.sh;
  filename = "jdk-1_5_0_06";
  dirname = "jdk1.5.0_06";
  pathname = "/tmp/jdk-1_5_0_06-linux-i586.bin";
  md5 = "3cdad4a383b93680f02f6f06198c2227";
  buildInputs = [unzip];
  libraries =
    (if swingSupport then [libX11 libXext] else []);
} // {inherit swingSupport;})
