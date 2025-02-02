{ lib
, stdenv
, fetchFromGitHub
, fetchpatch2
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
, wrapGAppsHook3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-desktop";
  version = "10.9.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-desktop";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-H+J/zFUjiXbr5ynDkkjrRsEbyO4LPOhqe8DdG60ikRw=";
  };

  patches = [
    ./plugins.patch

    # Fix workspace applet window icon click not performing workspace switch
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/524
    (fetchpatch2 {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/9b775d613ad0c324db628ed5a32d3fccc90f82d6.patch";
      hash = "sha256-QtPviPW7pJYZIs28CYwE3N8vcDswqnjD6d0WVPFchL4=";
    })

    # Work around even more SNI noncompliance
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/539
    (fetchpatch2 {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/84269e2fcdcac6d737ee5100881e8b306eaae570.patch";
      hash = "sha256-1Uj+6GZ9/oDQOt+5P8UYiVP3P0BrsJe3HqXVLkWCkAM=";
    })

    # vapi: Update libxfce4windowing to 4.19.3
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/546
    (fetchpatch2 {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/a040ccb96094f1d3a1ee81a6733c9434722bdf6c.patch";
      hash = "sha256-9eMYB5Zyn3BDYvAwORXTHaPGYDP7LnqHAwp+6Wy6XLk=";
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gtk-doc
    intltool
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook3
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
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gtk3
    ibus
    libcanberra-gtk3
    libgee
    libGL
    libnotify
    libpulseaudio
    libuuid
    libwnck
    magpie
    mesa
    polkit
    sassc
    upower
    xfce.libxfce4windowing
  ];

  propagatedBuildInputs = [
    # budgie-1.0.pc, budgie-raven-plugin-1.0.pc
    libpeas
  ];

  passthru.providedSessions = [
    "budgie-desktop"
  ];

  meta = {
    description = "Feature-rich, modern desktop designed to keep out the way of the user";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-desktop";
    license = with lib.licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30 ];
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
  };
})
