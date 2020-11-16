{ stdenv
, fetchurl
, pkgconfig
, gettext
, gobject-introspection
, wrapGAppsHook
, gjs
, glib
, gtk3
, gdk-pixbuf
, gst_all_1
, gnome3
, meson
, ninja
, python3
, desktop-file-utils
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-sound-recorder";
  version = "3.38.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "I5A/c2G+QQhw+6lHIJFnuW9JB2MGQdM8y6qOQvV0tpk=";
  };

  nativeBuildInputs = [
    pkgconfig
    gettext
    meson
    ninja
    gobject-introspection
    wrapGAppsHook
    python3
    desktop-file-utils
  ];

  buildInputs = [
    gjs
    glib
    gtk3
    gdk-pixbuf
    libhandy
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    gst-plugins-bad # for gstreamer-player-1.0
  ]);

  postPatch = ''
    chmod +x build-aux/meson_post_install.py
    patchShebangs build-aux/meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "gnome3.${pname}";
    };
  };

  meta = with stdenv.lib; {
    description = "A simple and modern sound recorder";
    homepage = "https://wiki.gnome.org/Apps/SoundRecorder";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
