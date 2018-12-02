{ stdenv, fetchFromGitHub, fetchpatch, autoconf-archive, appstream-glib, intltool, pkgconfig, libtool, wrapGAppsHook,
  dbus-glib, libcanberra, gst_all_1, vala, gnome3, gtk3, libxml2, autoreconfHook,
  glib, gobject-introspection, libpeas
}:

stdenv.mkDerivation rec {
  version = "0.13.4";
  name = "gnome-shell-pomodoro-${version}";

  src = fetchFromGitHub {
    owner = "codito";
    repo = "gnome-pomodoro";
    rev = "${version}";
    sha256 = "0fiql99nhj168wbfhvzrhfcm4c4569gikd2zaf10vzszdqjahrl1";
  };

  patches = [
    # build with Vala ≥ 0.42
    (fetchpatch {
      url = https://github.com/codito/gnome-pomodoro/commit/36778823ca5bd94b2aa948e5d8718f84d99d9af0.patch;
      sha256 = "0a9x0p5wny3an9xawam9nhpffw5m4kgwj5jvv0g6c2lwlfzrx2rh";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook vala autoconf-archive libtool intltool appstream-glib
    wrapGAppsHook pkgconfig libxml2
  ];

  buildInputs = [
    glib gobject-introspection libpeas
    dbus-glib libcanberra gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gnome3.gsettings-desktop-schemas
    gnome3.gnome-shell gtk3 gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = http://gnomepomodoro.org/;
    description = "A time management utility for GNOME based on the pomodoro technique";
    longDescription = ''
      This GNOME utility helps to manage time according to Pomodoro Technique.
      It intends to improve productivity and focus by taking short breaks.
    '';
    maintainers = with maintainers; [ jgeerds ];
    license = licenses.gpl3;
    platforms = platforms.linux;
  };
}
