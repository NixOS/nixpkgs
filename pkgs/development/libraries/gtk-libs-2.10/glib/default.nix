{stdenv, fetchurl, pkgconfig, gettext, perl}:

assert pkgconfig != null && gettext != null && perl != null;

stdenv.mkDerivation {
  name = "glib-2.12.9"; # <- sic! gtk 2.10 needs glib 2.12
  src = fetchurl {
    url = ftp://ftp.gtk.org/pub/glib/2.12/glib-2.12.9.tar.bz2;
    md5 = "b3f6a2a318610af6398b3445f1a2d6c6";
  };
  buildInputs = [pkgconfig gettext perl];
}
