{ swingSupport ? true
, stdenv, fetchurl, unzip, makeWrapper, libX11 ? null, libXext ? null
}:

assert stdenv.system == "powerpc-linux";

assert swingSupport -> libX11 != null && libXext != null;

(stdenv.mkDerivation {
  name = "jdk-1.5.0";
  builder = ./ibm-builder.sh;
  dirname = "ibm-java2-ppc-50";
  pathname = "/tmp/ibm-java2-sdk-50-linux-ppc.tgz";
  md5 = "6bed4ae0b24d3eea2914f2f6dcc0ceb4";
  libraries =
    (if swingSupport then [libX11 libXext] else []);
} // {inherit swingSupport;})
