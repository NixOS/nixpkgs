{ stdenv, fetchurl, pkgconfig, intltool, glib, gobjectIntrospection
  # just for passthru
, gtk3, gsettings_desktop_schemas }:

stdenv.mkDerivation rec {

  versionMajor = "3.12";
  versionMinor = "2";
  moduleName   = "gsettings-desktop-schemas";

  name = "${moduleName}-${versionMajor}.${versionMinor}";

  src = fetchurl {
    url = "mirror://gnome/sources/${moduleName}/${versionMajor}/${name}.tar.xz";
    sha256 = "da75021e9c45a60d0a97ea3486f93444275d0ace86dbd1b97e5d09000d8c4ad1";
  };

  buildInputs = [ glib gobjectIntrospection ];

  nativeBuildInputs = [ pkgconfig intltool ];
}
