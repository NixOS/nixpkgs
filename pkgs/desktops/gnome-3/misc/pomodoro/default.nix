{ stdenv, fetchFromGitHub, autoconf-archive, appstream-glib, intltool, pkgconfig, libtool, wrapGAppsHook,
  dbus_glib, libcanberra_gtk2, gst_all_1, vala, gnome3, gtk3, libxml2,
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

  configureScript = "./autogen.sh";

  nativeBuildInputs = [
    autoconf-archive libtool intltool appstream-glib
    wrapGAppsHook pkgconfig libxml2
  ];

  buildInputs = [
    glib gobjectIntrospection libpeas
    dbus_glib libcanberra_gtk2 vala gst_all_1.gstreamer
    gst_all_1.gst-plugins-base gst_all_1.gst-plugins-good
    gnome3.gsettings_desktop_schemas
    gnome3.gnome_common gnome3.gnome_shell gtk3
    gnome3.defaultIconTheme
  ];

  meta = with stdenv.lib; {
    homepage = https://github.com/codito/gnome-shell-pomodoro;
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
