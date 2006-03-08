{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./blackdown-i686.nix) {
      inherit stdenv fetchurl;
    }
  else
    null
