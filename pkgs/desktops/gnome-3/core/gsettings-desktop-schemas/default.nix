{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which }:

stdenv.mkDerivation rec {

  versionMajor = "3.5";
  versionMinor = "3";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "0vxbpwqvm55a4ssaddfsw2jy0q8bvsv8wbjps4yyyi9iykfylwli";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ gnome3.glib libxml2 libxslt libX11 ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];
}
