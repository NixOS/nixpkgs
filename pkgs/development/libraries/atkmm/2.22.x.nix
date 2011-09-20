{ stdenv, fetchurl_gnome, atk, glibmm, pkgconfig }:

stdenv.mkDerivation rec {
  name = src.pkgname;

  src = fetchurl_gnome {
    project = "atkmm";
    major = "2"; minor = "22"; patchlevel = "5";
    sha256 = "0v5ynws5pc4qdgrr8hrl8wajl3xxh3kgljchj7cqyb4mcxg3xq31";
  };

  propagatedBuildInputs = [ atk glibmm ];

  buildNativeInputs = [ pkgconfig ];
}
