{ stdenv, intltool, fetchurl, vala, libgtop
, pkgconfig, gtk3, glib
, bash, wrapGAppsHook, itstool, libxml2
, gnome3, librsvg, gdk_pixbuf, file }:

stdenv.mkDerivation rec {
  name = "baobab-${version}";
  version = "3.26.1";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "7a59ab5945f5d90725231b10d85a1893403f56660b1627c111d2b4eeb1ef787e";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "baobab"; };
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ vala gtk3 glib libgtop intltool itstool libxml2
                  wrapGAppsHook file gdk_pixbuf gnome3.defaultIconTheme librsvg ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Baobab;
    description = "Graphical application to analyse disk usage in any Gnome environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
