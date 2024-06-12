{ lib
, stdenv
, fetchFromGitHub
, substituteAll
, accountsservice
, budgie-desktop
, clutter
, clutter-gtk
, colord
, colord-gtk
, cups
, docbook-xsl-nons
, fontconfig
, gcr
, gdk-pixbuf
, gettext
, glib
, glib-networking
, glibc
, gnome
, gnome-desktop
, gsettings-desktop-schemas
, gsound
, gtk3
, ibus
, libcanberra-gtk3
, libepoxy
, libgnomekbd
, libgtop
, libgudev
, libhandy
, libkrb5
, libnma
, libpulseaudio
, libpwquality
, librsvg
, libsecret
, libwacom
, libxml2
, libxslt
, meson
, modemmanager
, networkmanager
, networkmanagerapplet
, ninja
, pkg-config
, polkit
, samba
, shadow
, shared-mime-info
, tzdata
, udisks2
, upower
, webp-pixbuf-loader
, wrapGAppsHook3
, enableSshSocket ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-control-center";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-control-center";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-W5PF7BPdQdg/7xJ4J+fEnuDdpoG/lyhX56RDnX2DXoY=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      budgie_desktop = budgie-desktop;
      gcm = gnome.gnome-color-manager;
      inherit cups glibc libgnomekbd shadow;
      inherit networkmanagerapplet tzdata;
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    shared-mime-info
    wrapGAppsHook3
  ];

  buildInputs = [
    accountsservice
    clutter
    clutter-gtk
    colord
    colord-gtk
    fontconfig
    gcr
    gdk-pixbuf
    glib
    glib-networking
    gnome-desktop
    gnome.adwaita-icon-theme
    gnome.cheese
    gnome.gnome-bluetooth_1_0
    gnome.gnome-remote-desktop
    gnome.gnome-settings-daemon
    gnome.gnome-user-share
    gnome.mutter
    gsettings-desktop-schemas
    gsound
    gtk3
    ibus
    libcanberra-gtk3
    libepoxy
    libgtop
    libgudev
    libhandy
    libkrb5
    libnma
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libwacom
    libxml2
    modemmanager
    networkmanager
    polkit
    samba
    udisks2
    upower
  ];

  mesonFlags = [
    (lib.mesonBool "ssh" enableSshSocket)
  ];

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  postInstall = ''
    # Pull in WebP support for gnome-backgrounds.
    # In postInstall to run before gappsWrapperArgsHook.
    export GDK_PIXBUF_MODULE_FILE="${gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
      extraLoaders = [
        librsvg
        webp-pixbuf-loader
      ];
    }}"
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      # Sound theme
      --prefix XDG_DATA_DIRS : "${budgie-desktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${gnome.mutter}/share"
    )
  '';

  separateDebugInfo = true;

  meta = {
    description = "Fork of GNOME Control Center for the Budgie 10 Series";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-control-center";
    mainProgram = "budgie-control-center";
    platforms = lib.platforms.linux;
    maintainers = lib.teams.budgie.members;
    license = lib.licenses.gpl2Plus;
  };
})
