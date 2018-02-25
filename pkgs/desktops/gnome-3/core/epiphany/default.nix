{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig, gtk, glib, icu
, wrapGAppsHook, gnome3, libxml2, libxslt, itstool
, webkitgtk, libsoup, glib-networking, libsecret, gnome-desktop, libnotify, p11-kit
, sqlite, gcr, isocodes, desktop-file-utils, file
, gdk_pixbuf, gnome-common, gst_all_1, json-glib }:

stdenv.mkDerivation rec {
  inherit (import ./src.nix fetchurl) name src;

  # Tests need an X display
  mesonFlags = [ "-Dunit_tests=false" ];

  propagatedUserEnvPkgs = [ gnome3.gnome-themes-standard ];

  nativeBuildInputs = [ meson ninja libxslt pkgconfig itstool gettext file wrapGAppsHook desktop-file-utils ];

  buildInputs = [ gtk glib webkitgtk libsoup libxml2 libsecret gnome-desktop libnotify
                  sqlite isocodes p11-kit icu gnome3.yelp-tools
                  gdk_pixbuf gnome3.defaultIconTheme gnome-common gcr
                  glib-networking gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
                  gst_all_1.gst-libav json-glib ];

  enableParallelBuilding = true;

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  postFixup = ''
    # Patched meson does not add internal libraries to rpath
    for f in $out/bin/.*-wrapped $out/libexec/.*-wrapped $out/libexec/epiphany/.*-wrapped $out/lib/epiphany/*.so $out/lib/epiphany/web-extensions/*.so; do
      patchelf --set-rpath "$out/lib/epiphany:$(patchelf --print-rpath $f)" "$f"
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
