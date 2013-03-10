{ stdenv, fetchurl, itstool, libxml2, gettext }:

stdenv.mkDerivation {
  name = "gnome-user-docs-3.2.2";

  src = fetchurl {
    url = mirror://gnome/sources/gnome-user-docs/3.2/gnome-user-docs-3.2.2.tar.xz;
    sha256 = "1ka0nw2kc85p10y8x31v0wv06a88k7qrgafp4ys04y9fzz0rkcjj";
  };

  nativeBuildInputs = [ itstool libxml2 gettext ];
}
