{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, glib, appstream-glib, gobjectIntrospection
, webkitgtk, gettext, itstool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.28.1";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "08a8xizjqz68k30zd37r7g516azhan9bbrjsvv10hjd5dg3f476s";
  };

  nativeBuildInputs = [ pkgconfig gettext itstool wrapGAppsHook appstream-glib gobjectIntrospection ];
  buildInputs = [
    glib gtk3 webkitgtk
    gnome3.defaultIconTheme gsettings-desktop-schemas
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "devhelp";
      attrPath = "gnome3.devhelp";
    };
  };

  meta = with stdenv.lib; {
    description = "API documentation browser for GNOME";
    homepage = https://wiki.gnome.org/Apps/Devhelp;
    license = licenses.gpl2;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
