{ stdenv, intltool, fetchurl, exempi, libxml2
, pkgconfig, gtk3, glib, tracker, tracker-miners
, makeWrapper, itstool, gegl, babl, lcms2
, desktop-file-utils, gmp, libmediaart, wrapGAppsHook
, gnome3, librsvg, gdk_pixbuf, libexif, gexiv2, geocode-glib
, dleyna-renderer }:

stdenv.mkDerivation rec {
  name = "gnome-photos-${version}";
  version = "3.26.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-photos/${gnome3.versionBranch version}/${name}.tar.xz";
    sha256 = "028de4c8662b7d1dc3ca6c3fbe3ce7f6bb90dd097708e99f235a409756dbadab";
  };

  passthru = {
    updateScript = gnome3.updateScript { packageName = "gnome-photos"; attrPath = "gnome3.gnome-photos"; };
  };

  # doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ gtk3 glib intltool itstool gegl babl gnome3.libgdata
                  gnome3.gsettings-desktop-schemas makeWrapper gmp libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg exempi
                  gnome3.gfbgraph gnome3.grilo-plugins gnome3.grilo
                  gnome3.gnome-online-accounts gnome3.gnome-desktop
                  lcms2 libexif tracker tracker-miners libxml2 desktop-file-utils
                  wrapGAppsHook gexiv2 geocode-glib dleyna-renderer ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Photos is an application to access, organize and share your photos with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
