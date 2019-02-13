{ stdenv, fetchurl, meson, ninja, intltool, gst_all_1
, clutter-gtk, clutter-gst, python3Packages, shared-mime-info
, pkgconfig, gtk3, glib, gobject-introspection, totem-pl-parser
, wrapGAppsHook, itstool, libxml2, vala, gnome3
, gdk_pixbuf, tracker, nautilus }:

stdenv.mkDerivation rec {
  name = "totem-${version}";
  version = "3.30.0";

  src = fetchurl {
    url = "mirror://gnome/sources/totem/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0rahkybxbmxhlmrrgrzxny1xm7wycx7ib4blxp1i2l1q3i8s84b0";
  };

  doCheck = true;

  NIX_CFLAGS_COMPILE = "-I${gnome3.glib.dev}/include/gio-unix-2.0";

  nativeBuildInputs = [ meson ninja vala pkgconfig intltool python3Packages.python itstool gobject-introspection wrapGAppsHook ];
  buildInputs = [
    gtk3 glib gnome3.grilo clutter-gtk clutter-gst totem-pl-parser gnome3.grilo-plugins
    gst_all_1.gstreamer gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly gst_all_1.gst-libav gnome3.libpeas shared-mime-info
    gdk_pixbuf libxml2 gnome3.defaultIconTheme gnome3.gnome-desktop
    gnome3.gsettings-desktop-schemas tracker nautilus
    python3Packages.pygobject3 python3Packages.dbus-python # for plug-ins
  ];

  postPatch = ''
    chmod +x meson_compile_python.py meson_post_install.py # patchShebangs requires executable file
    patchShebangs .
  '';

  mesonFlags = [
    "-Dwith-nautilusdir=${placeholder "out"}/lib/nautilus/extensions-3.0"
    # https://bugs.launchpad.net/ubuntu/+source/totem/+bug/1712021
    # https://bugzilla.gnome.org/show_bug.cgi?id=784236
    # https://github.com/mesonbuild/meson/issues/1994
    "-Denable-vala=no"
  ];

  wrapPrefixVariables = [ "PYTHONPATH" ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "totem";
      attrPath = "gnome3.totem";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/Videos;
    description = "Movie player for the GNOME desktop based on GStreamer";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
