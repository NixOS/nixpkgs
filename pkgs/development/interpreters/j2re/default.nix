{stdenv, fetchurl}: 

if stdenv.system == "i686-linux"
  then
    (import ./j2re-sun-linux.nix) {
      stdenv   = stdenv;
      fetchurl = fetchurl;
    }
  else
    false
