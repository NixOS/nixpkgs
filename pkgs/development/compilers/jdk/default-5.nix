{stdenv, fetchurl, unzip}: 

if stdenv.system == "i686-linux"
  then
    (import ./jdk5-sun-linux.nix) {
      inherit stdenv fetchurl unzip;
    }
  else
    abort "the Java 5 SDK is not supported on this platform"
