{ stdenv, fetchurl, pkgconfig, cairo, libxml2, libxslt, gnome3, pango
, gnome_doc_utils, intltool, libX11, which, gconf }:

stdenv.mkDerivation rec {

  versionMajor = "3.4";
  versionMinor = "1.1";

  name = "gnome-terminal-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-terminal/${versionMajor}/${name}.tar.xz";
    sha256 = "1p9zqjmkxryf2kyghhhwwpsh4kd8y1jzzwc9zxghmpxszi9a5m0l";
  };

  configureFlags = "--disable-scrollkeeper";
  buildInputs = [ gnome3.gtk gnome3.gsettings_desktop_schemas gnome3.vte gconf ];

  nativeBuildInputs = [ pkgconfig intltool gnome_doc_utils which ];
}
