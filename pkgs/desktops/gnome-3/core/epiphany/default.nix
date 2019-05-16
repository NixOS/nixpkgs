{ stdenv, meson, ninja, gettext, fetchurl, pkgconfig, gtk3, glib, icu
, wrapGAppsHook, gnome3, libxml2, libxslt, itstool
, webkitgtk, libsoup, glib-networking, libsecret, gnome-desktop, libnotify, p11-kit
, sqlite, gcr, isocodes, desktop-file-utils, python3
, gdk_pixbuf, gst_all_1, json-glib, libdazzle, libhandy }:

stdenv.mkDerivation rec {
  name = "epiphany-${version}";
  version = "3.32.2";

  src = fetchurl {
    url = "mirror://gnome/sources/epiphany/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1yhc8hpylj7i2i15nrbjldhi38xpz7pdwjdj7b358dxsxaghvrwa";
  };

  # Tests need an X display
  mesonFlags = [ "-Dunit_tests=disabled" ];

  nativeBuildInputs = [
    meson ninja libxslt pkgconfig itstool gettext wrapGAppsHook desktop-file-utils python3
  ];

  buildInputs = [
    gtk3 glib webkitgtk libsoup libxml2 libsecret gnome-desktop libnotify
    sqlite isocodes p11-kit icu libhandy
    gdk_pixbuf gnome3.adwaita-icon-theme gcr
    glib-networking gst_all_1.gstreamer gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad gst_all_1.gst-plugins-ugly
    gst_all_1.gst-libav json-glib libdazzle
  ];

  postPatch = ''
    chmod +x post_install.py # patchShebangs requires executable file
    patchShebangs post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "epiphany";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Epiphany;
    description = "WebKit based web browser for GNOME";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
