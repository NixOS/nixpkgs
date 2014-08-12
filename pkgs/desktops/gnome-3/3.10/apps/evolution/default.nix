{ stdenv, intltool, fetchurl, libxml2, webkitgtk, highlight
, pkgconfig, gtk3, glib, hicolor_icon_theme, libnotify
, makeWrapper, itstool, shared_mime_info, libical, db
, gnome3, librsvg, gdk_pixbuf, libsecret, nss, nspr, icu
, libcanberra_gtk3, bogofilter, gst_all_1, procps }:

stdenv.mkDerivation rec {
  name = "evolution-3.10.4";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution/3.10/${name}.tar.xz";
    sha256 = "ac60557f264f211e6a7bc0ced919041c154e4c7b9c79600516aee7acc1d03e40";
  };

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  buildInputs = [ pkgconfig gtk3 glib intltool itstool libxml2
                  gdk_pixbuf gnome3.gnome_icon_theme librsvg db icu
                  gnome3.evolution_data_server libsecret libical
                  webkitgtk shared_mime_info gnome3.gnome_desktop
                  libcanberra_gtk3 gnome3.gtkhtml bogofilter gnome3.libgdata
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  hicolor_icon_theme gnome3.gnome_icon_theme_symbolic
                  nss nspr libnotify procps highlight gnome3.libgweather
                  gnome3.gsettings_desktop_schemas makeWrapper ];

  configureFlags = [ "--disable-spamassassin" "--disable-pst-import" ];

  NIX_CFLAGS_COMPILE = "-I${nspr}/include/nspr -I${nss}/include/nss";

  enableParallelBuilding = true;

  preFixup = ''
    wrapProgram "$out/bin/evolution" \
      --set GDK_PIXBUF_MODULE_FILE "$GDK_PIXBUF_MODULE_FILE" \
      --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Evolution;
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    maintainers = with maintainers; [ lethalman ];
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
