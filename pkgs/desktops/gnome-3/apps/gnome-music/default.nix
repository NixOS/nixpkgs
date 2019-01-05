{ stdenv, meson, ninja, gettext, fetchurl, gdk_pixbuf, tracker
, libxml2, python3, libnotify, wrapGAppsHook, libmediaart
, gobject-introspection, gnome-online-accounts, grilo, grilo-plugins
, pkgconfig, gtk3, glib, desktop-file-utils, appstream-glib
, itstool, gnome3, gst_all_1, libdazzle, libsoup }:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-music";
  version = "3.30.2";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1d9gd9rqy71hibfrz4zglimvgv6yn1pw22cnrn7pbdz6k4yq209d";
  };

  nativeBuildInputs = [ meson ninja gettext itstool pkgconfig libxml2 wrapGAppsHook desktop-file-utils appstream-glib gobject-introspection ];
  buildInputs = with gst_all_1; [
    gtk3 glib libmediaart gnome-online-accounts
    gdk_pixbuf gnome3.defaultIconTheme python3
    grilo grilo-plugins libnotify libdazzle libsoup
    gnome3.gsettings-desktop-schemas tracker
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
  ];
  propagatedBuildInputs = with python3.pkgs; [ pycairo dbus-python pygobject3 ];


  postPatch = ''
    for f in meson_post_conf.py meson_post_install.py; do
      chmod +x $f
      patchShebangs $f
    done
  '';

  doCheck = false;

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Music;
    description = "Music player and management application for the GNOME desktop environment";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
