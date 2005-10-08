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
{ swingSupport ? true
, stdenv, fetchurl, unzip, patchelf, libX11 ? null, libXext ? null
}:

assert stdenv.system == "i686-linux";

assert swingSupport -> libX11 != null && libXext != null;

(stdenv.mkDerivation {
  name = "jdk-1.5.0";
  builder = ./builder.sh;
  filename = "jdk-1_5_0_05";
  dirname = "jdk1.5.0_05";
  pathname = "/tmp/jdk-1_5_0_05-linux-i586.bin";
  md5 = "2f83bf2a38fff1f8ac51b02ec7391ca3";
  buildInputs = [unzip patchelf];
  libraries =
    (if swingSupport then [libX11 libXext] else []);
} // {inherit swingSupport;})
