{ stdenv, fetchFromGitHub, autoconf-archive, appstream-glib, intltool, pkgconfig, libtool, wrapGAppsHook,
  dbus-glib, libcanberra, gst_all_1, vala, gnome3, gtk3, libxml2, autoreconfHook,
  glib, gobjectIntrospection, libpeas
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

  nativeBuildInputs = [
    autoreconfHook vala autoconf-archive libtool intltool appstream-glib
    wrapGAppsHook pkgconfig libxml2
  ];

  buildInputs = [
    glib gobjectIntrospection libpeas
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
