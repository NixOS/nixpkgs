{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2sdk-sun-linux.nix) {
      inherit stdenv fetchurl;
    }
  else
    false
