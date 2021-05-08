{ lib, stdenv
, fetchurl
, pkg-config
, gettext
, gobject-introspection
, wrapGAppsHook
, gjs
, glib
, gtk3
, gdk-pixbuf
, gst_all_1
, gnome
, meson
, ninja
, python3
, desktop-file-utils
, libhandy
}:

stdenv.mkDerivation rec {
  pname = "gnome-sound-recorder";
  version = "40.0";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.major version}/${pname}-${version}.tar.xz";
    sha256 = "00b55vsfzx877b7mj744abzjws7zclz71wbvh0axsrbl9l84ranl";
  };

  nativeBuildInputs = [
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = pname;
      attrPath = "gnome.${pname}";
    };
  };

  meta = with lib; {
    description = "A simple and modern sound recorder";
    homepage = "https://wiki.gnome.org/Apps/SoundRecorder";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
}
