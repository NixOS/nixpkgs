{ stdenv, intltool, fetchurl, libxml2, upower
, pkgconfig, gtk3, glib, hicolor_icon_theme
, bash, makeWrapper, itstool, vala, sqlite
, gnome3, librsvg, gdk_pixbuf, file, libnotify
, evolution_data_server, gst_all_1, poppler
, icu, taglib, libjpeg, libtiff, giflib, libcue
, libvorbis, flac, exempi, networkmanager
, libpng, libexif, libgsf, libuuid, bzip2 }:

stdenv.mkDerivation rec {
  name = "tracker-1.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/tracker/1.0/${name}.tar.xz";
    sha256 = "76e7918e62526a8209f9c9226f82abe592a6332826ac7c12e6e405063181e889";
  };

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  buildInputs = [ vala pkgconfig gtk3 glib intltool itstool libxml2
                  bzip2 gnome3.totem-pl-parser
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg sqlite
                  upower libnotify evolution_data_server gnome3.libgee
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base flac
                  poppler icu taglib libjpeg libtiff giflib libvorbis
                  exempi networkmanager libpng libexif libgsf libuuid
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram $f \
        --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Tracker;
    description = "Desktop-neutral user information store, search tool and indexer";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
