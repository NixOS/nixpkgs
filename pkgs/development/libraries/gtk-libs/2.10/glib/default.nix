args: with args;

stdenv.mkDerivation {
  name = "glib-2.12.13"; # <- sic! gtk 2.10 needs glib 2.12
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/glib/2.12/glib-2.12.13.tar.gz;
    sha256 = "1aa3jq7l6qv2pm4y0zn9zjnh1sbkynibybmiydghj02c89d3d000";
  };
  buildInputs = [pkgconfig gettext perl];
}
