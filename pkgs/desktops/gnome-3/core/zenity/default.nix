{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which }:

stdenv.mkDerivation rec {

  versionMajor = "3.4";
  versionMinor = "0";

  name = "zenity-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/zenity/${versionMajor}/zenity-${versionMajor}.${versionMinor}.tar.xz";
    sha256 = "1bqbfcvd3kj2xk15fvbcdaqvyg9qvymlhn8cwvg5m6v4gicniw2w";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ gnome3.gtk libxml2 libxslt libX11 ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];
}
