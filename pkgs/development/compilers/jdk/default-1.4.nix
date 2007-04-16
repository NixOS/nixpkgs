{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2sdk-1.4.x-sun-linux.nix) {
      inherit stdenv fetchurl;
    }
  else
    abort "the Java 2 SDK is not supported on this platform"
