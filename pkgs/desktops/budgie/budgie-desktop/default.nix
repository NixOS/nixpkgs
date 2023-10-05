{ lib
, stdenv
, fetchFromGitHub
, accountsservice
, alsa-lib
, budgie-screensaver
, docbook-xsl-nons
, glib
, gnome
, gnome-desktop
, gnome-menus
, graphene
, gst_all_1
, gtk-doc
, gtk3
, ibus
, intltool
, libcanberra-gtk3
, libgee
, libGL
, libnotify
, libpeas
, libpulseaudio
, libuuid
, libwnck
, magpie
, mesa
, meson
, ninja
, pkg-config
, polkit
, sassc
, upower
, vala
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "budgie-desktop";
  version = "10.8.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-KhCQ5v6R6sS5Vjl10QhSuAxAPTDDAvJ6uu6VKTdX7m4=";
  };

  patches = [
    ./plugins.patch
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    alsa-lib
    budgie-screensaver
    glib
    gnome-desktop
    gnome-menus
    gnome.gnome-bluetooth_1_0
    gnome.gnome-settings-daemon
    gnome.zenity
    graphene
    gtk3
    ibus
    libcanberra-gtk3
    libgee
    libGL
    libnotify
    libpeas
    libpulseaudio
    libuuid
    libwnck
    magpie
    mesa
    polkit
    sassc
    upower
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  passthru.providedSessions = [
    "budgie-desktop"
  ];

  meta = with lib; {
    description = "A feature-rich, modern desktop designed to keep out the way of the user";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop";
    platforms = platforms.linux;
    maintainers = [ maintainers.federicoschonborn ];
    license = with licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30 ];
  };
}
