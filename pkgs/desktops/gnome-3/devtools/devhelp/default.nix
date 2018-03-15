{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, glib, appstream-glib, gobjectIntrospection
, webkitgtk, gettext, itstool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1b4l71775p3mps1jsv7pz26v0lhd0qczsp6qr1dwv7hyslmpb5qn";
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
