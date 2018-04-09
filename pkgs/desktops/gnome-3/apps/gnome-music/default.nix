{ stdenv, meson, ninja, gettext, fetchurl, gdk_pixbuf, tracker
, libxml2, python3, libnotify, wrapGAppsHook, libmediaart
, gobjectIntrospection, gnome-online-accounts, grilo, grilo-plugins
, pkgconfig, gtk3, glib, cairo, desktop-file-utils, appstream-glib
, itstool, gnome3, gst_all_1 }:

python3.pkgs.buildPythonApplication rec {
  pname = "gnome-music";
  version = "3.28.0.1";

  format = "other";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${gnome3.versionBranch version}/${pname}-${version}.tar.xz";
    sha256 = "0yyysmxwmk167n8wghcbmxz73kgl1y1j9js3mgkjjqsmkd9brk65";
  };

  nativeBuildInputs = [ meson ninja gettext itstool pkgconfig libxml2 wrapGAppsHook desktop-file-utils appstream-glib gobjectIntrospection ];
  buildInputs = with gst_all_1; [
    gtk3 glib libmediaart gnome-online-accounts
    gdk_pixbuf gnome3.defaultIconTheme python3
    grilo grilo-plugins libnotify
    gnome3.gsettings-desktop-schemas tracker
    gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad gst-plugins-ugly
  ];
  propagatedBuildInputs = with python3.pkgs; [ pycairo dbus-python requests pygobject3 ];


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
