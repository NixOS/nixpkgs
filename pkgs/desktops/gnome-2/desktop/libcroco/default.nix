{stdenv, fetchurl, pkgconfig, libxml2, glib}:

stdenv.mkDerivation {
  name = "libcroco-0.6.4";

  src = fetchurl {
    url = mirror://gnome/sources/libcroco/0.6/libcroco-0.6.4.tar.xz;
    sha256 = "1sij88na1skd4d5dx75l803fww3v9872q8m2hj6sjlkc839vl5n8";
  };
  buildInputs = [ pkgconfig libxml2 glib ];
}
