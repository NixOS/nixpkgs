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
, xfce
, wrapGAppsHook
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.9";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-yyuLBzTDEQH7rBOWTYBvS+3x2mlbF34f7U7oOUO8BeA=";
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
    gnome.gnome-settings-daemon
    gnome.mutter
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
    xfce.libxfce4windowing
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
  ]);

  passthru.providedSessions = [
    "budgie-desktop"
  ];

  meta = {
    description = "A feature-rich, modern desktop designed to keep out the way of the user";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30 ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ federicoschonborn ];
  };
})
