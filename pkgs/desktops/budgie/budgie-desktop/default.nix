{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "10.7.2";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = pname;
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-fd3B2DMZxCI4Gb9mwdACjIPydKghXx8IkhFpMS/Clps=";
  };

  patches = [
    # Drop all Vapi files that are already included with Vala
    # https://github.com/BuddiesOfBudgie/budgie-desktop/commit/5f641489a00cc244e50aa1ceae04f952d58389d2
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/5f641489a00cc244e50aa1ceae04f952d58389d2.patch";
      hash = "sha256-Cyj/+G1dx0DKCTtzVESzFZ+I5o7INopGvw7bq5o/abo=";
    })

    # Add support for Magpie
    # https://github.com/BuddiesOfBudgie/budgie-desktop/pull/387
    (fetchpatch {
      url = "https://github.com/BuddiesOfBudgie/budgie-desktop/commit/84ccb505160322536043717c3b8f970ab91b0103.patch";
      hash = "sha256-4nd7Tk4ajyVy8cGDNIINpW9jlyRNywPYMrhBCtJVHZk=";
    })

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
    license = with licenses; [ gpl2Plus lgpl21Plus cc-by-sa-30];
  };
}
