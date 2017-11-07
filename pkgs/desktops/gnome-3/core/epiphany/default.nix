{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig, gtk, glib, icu
, wrapGAppsHook, gnome3, libxml2, libxslt, itstool
, webkitgtk, libsoup, glib_networking, libsecret, gnome_desktop, libnotify, p11_kit
, sqlite, gcr, isocodes, desktop_file_utils, file
, gdk_pixbuf, gnome_common, gst_all_1, json_glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Tests need an X display
  mesonFlags = [ "-Dunit_tests=false" ];

  propagatedUserEnvPkgs = [ gnome3.gnome_themes_standard ];

  nativeBuildInputs = [ meson ninja libxslt pkgconfig itstool gettext file wrapGAppsHook desktop_file_utils ];

  buildInputs = [ gtk glib webkitgtk libsoup libxml2 libsecret gnome_desktop libnotify
                  sqlite isocodes p11_kit icu gnome3.yelp_tools
                  gdk_pixbuf gnome3.defaultIconTheme gnome_common gcr
                  glib_networking gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
                  gst_all_1.gst-libav json_glib ];

  enableParallelBuilding = true;

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  postFixup = ''
    # Patched meson does not add internal libraries to rpath
    for f in bin/.epiphany-wrapped libexec/.epiphany-search-provider-wrapped libexec/epiphany/.ephy-profile-migrator-wrapped lib/epiphany/web-extensions/libephywebextension.so; do
      patchelf --set-rpath "$out/lib/epiphany:$(patchelf --print-rpath $out/$f)" "$out/$f"
    done
  '';

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
