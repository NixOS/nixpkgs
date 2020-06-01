{ stdenv, fetchurl, meson, ninja, gettext, gst_all_1
, clutter-gtk, clutter-gst, python3Packages, shared-mime-info
, pkgconfig, gtk3, glib, gobject-introspection, totem-pl-parser
, wrapGAppsHook, itstool, libxml2, vala, gnome3, grilo, grilo-plugins
, libpeas, adwaita-icon-theme, gnome-desktop, gsettings-desktop-schemas
, gdk-pixbuf, tracker, nautilus, xvfb_run }:

stdenv.mkDerivation rec {
  pname = "totem";
  version = "3.34.1";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "028sc6xbyi7rs884862d8f3di6zhcm0lhvlpc3r69ifzjsq9my3b";
  };

  doCheck = true;

  nativeBuildInputs = [ meson ninja vala pkgconfig gettext python3Packages.python itstool gobject-introspection wrapGAppsHook ];
  buildInputs = [
    gtk3 glib grilo clutter-gtk clutter-gst totem-pl-parser grilo-plugins
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly gst_all_1.gst-libav libpeas shared-mime-info
    gdk-pixbuf libxml2 adwaita-icon-theme gnome-desktop
    gsettings-desktop-schemas tracker nautilus
    python3Packages.pygobject3 python3Packages.dbus-python # for plug-ins
  ];

  postPatch = ''
    chmod +x meson_compile_python.py meson_post_install.py # patchShebangs requires executable file
    patchShebangs .
  '';

  checkInputs = [ xvfb_run ];

  checkPhase = ''
    xvfb-run -s '-screen 0 800x600x24' \
      ninja test
  '';

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "totem";
      attrPath = "gnome3.totem";
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://wiki.gnome.org/Apps/Videos";
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = teams.gnome.members;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
