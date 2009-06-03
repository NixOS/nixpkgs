{stdenv, fetchurl, pkgconfig, gettext, gtk}:

stdenv.mkDerivation {
  name = "libunique-1.0.8";
  src = fetchurl {
    url = mirror://gnome/sources/libunique/1.0/libunique-1.0.8.tar.bz2;
    sha256 = "1iplvmc41h64kdrsgpvb03mawzvflarvlpk5mng4xw9sa87s29yn";
  };
  buildInputs = [ pkgconfig gettext gtk ];
}
