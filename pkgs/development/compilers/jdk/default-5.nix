{stdenv, fetchurl, unzip}: 

if stdenv.system == "i686-linux" || stdenv.system == "x86_64-linux"
  then
    (import ./jdk5-oracle-linux.nix) {
      inherit stdenv fetchurl unzip;
    }
  else
    abort "the Java 5 SDK is not supported on this platform"
