{ stdenv
, fetchFromGitHub
, autoconf-archive
, appstream-glib
, pkgconfig
, wrapGAppsHook
, libcanberra
, gst_all_1
, vala
, gtk3
, gom
, sqlite
, libxml2
, autoreconfHook
, glib
, gobject-introspection
, libpeas
, gnome-shell
, gsettings-desktop-schemas
, adwaita-icon-theme
, gettext
}:

stdenv.mkDerivation rec {
  pname = "gnome-shell-pomodoro";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "codito";
    repo = "gnome-pomodoro";
    rev = version;
    sha256 = "0nmgd122gsfka0p50mila88iwrzckq2r36a3h20lswn5qkn321i1";
  };

  nativeBuildInputs = [
    appstream-glib
    autoconf-archive
    autoreconfHook
    gettext
    gobject-introspection
    libxml2
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    adwaita-icon-theme
    glib
    gnome-shell
    gom
    gsettings-desktop-schemas
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gstreamer
    gtk3
    libcanberra
    libpeas
    sqlite
  ];

  meta = with stdenv.lib; {
    homepage = https://gnomepomodoro.org/;
    description = "Time management utility for GNOME based on the pomodoro technique";
    longDescription = ''
      This GNOME utility helps to manage time according to Pomodoro Technique.
      It intends to improve productivity and focus by taking short breaks.
    '';
    maintainers = with maintainers; [ worldofpeace ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
