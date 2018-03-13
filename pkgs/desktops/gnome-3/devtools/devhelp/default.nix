{ stdenv, fetchurl, pkgconfig, gnome3, gtk3, wrapGAppsHook
, webkitgtk, intltool, gsettings-desktop-schemas }:

stdenv.mkDerivation rec {
  name = "devhelp-${version}";
  version = "3.28.0";

  src = fetchurl {
    url = "mirror://gnome/sources/devhelp/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "1b4l71775p3mps1jsv7pz26v0lhd0qczsp6qr1dwv7hyslmpb5qn";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "devhelp"; attrPath = "gnome3.devhelp"; };
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    gtk3 wrapGAppsHook webkitgtk intltool gnome3.defaultIconTheme
    gsettings-desktop-schemas
  ];

  meta = with stdenv.lib; {
    homepage = https://live.gnome.org/devhelp;
    description = "API documentation browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
