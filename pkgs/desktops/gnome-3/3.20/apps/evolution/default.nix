{ stdenv, intltool, fetchurl, libxml2, webkitgtk, highlight
, pkgconfig, gtk3, glib, libnotify, gtkspell3
, wrapGAppsHook, itstool, shared_mime_info, libical, db, gcr, sqlite
, gnome3, librsvg, gdk_pixbuf, libsecret, nss, nspr, icu, libtool
, libcanberra_gtk3, bogofilter, gst_all_1, procps, p11_kit, dconf }:

let
  majVer = gnome3.version;
in stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  doCheck = true;

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard
                            gnome3.evolution_data_server ];

  propagatedBuildInputs = [ gnome3.gtkhtml ];

  buildInputs = [ gtk3 glib intltool itstool libxml2 libtool
                  gdk_pixbuf gnome3.defaultIconTheme librsvg db icu
                  gnome3.evolution_data_server libsecret libical gcr
                  webkitgtk shared_mime_info gnome3.gnome_desktop gtkspell3
                  libcanberra_gtk3 bogofilter gnome3.libgdata sqlite
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base p11_kit
                  nss nspr libnotify procps highlight gnome3.libgweather
                  gnome3.gsettings_desktop_schemas dconf
                  gnome3.libgnome_keyring gnome3.glib_networking ];

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  configureFlags = [ "--disable-spamassassin" "--disable-pst-import" "--disable-autoar"
                     "--disable-libcryptui" ];

  NIX_CFLAGS_COMPILE = "-I${nspr.dev}/include/nspr -I${nss.dev}/include/nss -I${glib.dev}/include/gio-unix-2.0";

  enableParallelBuilding = true;

  requiredSystemFeatures = [ "big-parallel" ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Evolution;
    description = "Personal information management application that provides integrated mail, calendaring and address book functionality";
    maintainers = gnome3.maintainers;
    license = licenses.lgpl2Plus;
    platforms = platforms.linux;
  };
}
