{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2sdk-sun-linux.nix) {
      fetchurl = fetchurl;
    }
  else
    false
