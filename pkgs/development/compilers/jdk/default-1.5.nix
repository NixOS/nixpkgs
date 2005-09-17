{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2sdk1.5-sun-linux.nix) {
      stdenv   = stdenv;
      fetchurl = fetchurl;
    }
  else
    false
