{stdenv, fetchurl_gnome, pkgconfig, gtk}:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "libunique";
    major = "1"; minor = "1"; patchlevel = "6";
    sha256 = "1fsgvmncd9caw552lyfg8swmsd6bh4ijjsph69bwacwfxwf09j75";
  };

  buildNativeInputs = [ pkgconfig ];
  buildInputs = [ gtk ];
}
