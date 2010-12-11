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
{stdenv, fetchurl, unzip, requireFile}: 

assert stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux";

stdenv.mkDerivation rec {
  name =  "jdk-1_5_0_22";
  dirname = "jdk1.5.0_22";
  builder = ./builder.sh;
  src = requireFile {
    message = ''
      SORRY!
      We may not download the needed binary distribution automatically.
      You should download ${distfilename} from Sun and add it to store.
      For example, "nix-prefetch-url file:///\$PWD/${distfilename}" in the 
      directory where you saved it is OK.
      Blame Sun, not us.
    '';
    name = distfilename;
    sha256 = if stdenv.system == "x86_64-linux" then 
      "1h63gigvg8id95igcj8xw7qvxs4p2y9hvx4xbvkwg8bji3ifb0sk" 
    else "0655n2q1y023zzwbk6gs9vwsnb29jc0m3bg3x3xdw623qgb4k6px";
  };
  distfilename = if stdenv.system == "x86_64-linux" then "${name}-linux-amd64.bin" else "${name}-linux-i586.bin";
  
  inherit unzip stdenv;
}
