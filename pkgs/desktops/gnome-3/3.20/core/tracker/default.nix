{ stdenv, intltool, fetchurl, libxml2, upower
, pkgconfig, gtk3, glib
, bash, makeWrapper, itstool, vala_0_32, sqlite, libxslt
, gnome3, librsvg, gdk_pixbuf, file, libnotify
, evolution_data_server, gst_all_1, poppler
, icu, taglib, libjpeg, libtiff, giflib, libcue
, libvorbis, flac, exempi, networkmanager
, libpng, libexif, libgsf, libuuid, bzip2 }:

stdenv.mkDerivation rec {

  inherit (import ./src.nix fetchurl) name src;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0 -I${poppler.dev}/include/poppler";

  enableParallelBuilding = true;

  buildInputs = [ vala_0_32 pkgconfig gtk3 glib intltool itstool libxml2
                  bzip2 gnome3.totem-pl-parser libxslt
                  gnome3.gsettings_desktop_schemas makeWrapper file
                  gdk_pixbuf gnome3.defaultIconTheme librsvg sqlite
                  upower libnotify evolution_data_server gnome3.libgee
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base flac
                  poppler icu taglib libjpeg libtiff giflib libvorbis
                  exempi networkmanager libpng libexif libgsf libuuid ];

  preConfigure = ''
    substituteInPlace src/libtracker-sparql/Makefile.in --replace "--shared-library=libtracker-sparql" "--shared-library=$out/lib/libtracker-sparql"
  '';

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
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
