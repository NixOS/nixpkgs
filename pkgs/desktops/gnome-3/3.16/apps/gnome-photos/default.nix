{ stdenv, intltool, fetchurl, exempi, libxml2
, pkgconfig, gtk3, glib, hicolor_icon_theme
, makeWrapper, itstool, gegl, babl, lcms2
, desktop_file_utils, gmp, libmediaart
, gnome3, librsvg, gdk_pixbuf, libexif }:

stdenv.mkDerivation rec {
  name = "gnome-photos-${gnome3.version}.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-photos/${gnome3.version}/${name}.tar.xz";
    sha256 = "0jv3b5nd4sazyq2k132rdjizfg24sj6i63ls1m6x2qqqf8grxznj";
  };

  # doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  buildInputs = [ pkgconfig gtk3 glib intltool itstool gegl babl gnome3.libgdata
                  gnome3.gsettings_desktop_schemas makeWrapper gmp libmediaart
                  gdk_pixbuf gnome3.adwaita-icon-theme librsvg exempi
                  gnome3.gfbgraph gnome3.grilo-plugins gnome3.grilo
                  gnome3.gnome_online_accounts gnome3.gnome_desktop
                  lcms2 libexif gnome3.tracker libxml2 desktop_file_utils
                  hicolor_icon_theme gnome3.adwaita-icon-theme ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix GRL_PLUGIN_PATH : "${gnome3.grilo-plugins}/lib/grilo-0.2" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Photos;
    description = "Photos is an application to access, organize and share your photos with GNOME 3";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
