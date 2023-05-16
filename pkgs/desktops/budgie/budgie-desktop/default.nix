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
<<<<<<< HEAD
, magpie
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  version = "10.8";
=======
  version = "10.7.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
<<<<<<< HEAD
    hash = "sha256-fOsTBnKtwBGQSPkBBrzwHEB3+OcJYtPIdvZsV31oi6g=";
=======
    hash = "sha256-fd3B2DMZxCI4Gb9mwdACjIPydKghXx8IkhFpMS/Clps=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======
    gnome.mutter
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    magpie
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    license = with licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30 ];
=======
    license = with licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
