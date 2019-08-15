{ stdenv, fetchurl, pkgconfig, gettext, gobject-introspection, wrapGAppsHook, gjs, glib, gtk3, gdk-pixbuf, gst_all_1, gnome3
, meson, ninja, python3, hicolor-icon-theme, desktop-file-utils }:

stdenv.mkDerivation rec {
  pname = "gnome-sound-recorder";
  version = "3.32.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0q83b6dabckmwj8mcw0wvhbxaszwdzzcf8ajx5bldll3lyl5yh2b";
  };

  nativeBuildInputs = [
    pkgconfig gettext meson ninja gobject-introspection
    wrapGAppsHook python3 hicolor-icon-theme desktop-file-utils
  ];
  buildInputs = [ gjs glib gtk3 gdk-pixbuf ] ++ (with gst_all_1; [ gstreamer.dev gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad ]);

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  # TODO: fix this in gstreamer
  # TODO: make stdenv.lib.getBin respect outputBin
  PKG_CONFIG_GSTREAMER_1_0_TOOLSDIR = "${gst_all_1.gstreamer.dev}/bin";

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A simple and modern sound recorder";
    homepage = https://wiki.gnome.org/Apps/SoundRecorder;
    license = licenses.gpl2Plus;
    maintainers = gnome3.maintainers;
    platforms = platforms.linux;
  };
}
