{ stdenv, intltool, fetchurl, exempi, libxml2
, pkgconfig, gtk3, glib
, makeWrapper, itstool, gegl, babl, lcms2
, desktop_file_utils, gmp, libmediaart, wrapGAppsHook
, gnome3, librsvg, gdk_pixbuf, libexif }:

stdenv.mkDerivation rec {
  name = "gnome-photos-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-photos/${gnome3.version}/${name}.tar.xz";
    sha256 = "0jv3b5nd4sazyq2k132rdjizfg24sj6i63ls1m6x2qqqf8grxznj";
  };

  # doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gegl babl gnome3.libgdata
                  gnome3.gsettings_desktop_schemas makeWrapper gmp libmediaart
                  gdk_pixbuf gnome3.defaultIconTheme librsvg exempi
                  gnome3.gfbgraph gnome3.grilo-plugins gnome3.grilo
                  gnome3.gnome_online_accounts gnome3.gnome_desktop
                  lcms2 libexif gnome3.tracker libxml2 desktop_file_utils
                  wrapGAppsHook ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Photos is an application to access, organize and share your photos with GNOME 3";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
