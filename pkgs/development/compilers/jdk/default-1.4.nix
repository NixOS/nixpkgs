{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2sdk-1.4.x-sun-linux.nix) {
      inherit stdenv fetchurl;
    }
  else
    false
