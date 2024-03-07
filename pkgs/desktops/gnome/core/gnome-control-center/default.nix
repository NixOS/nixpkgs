{ fetchurl
, lib
, stdenv
, substituteAll
, accountsservice
, adwaita-icon-theme
, colord
, colord-gtk4
, cups
, docbook-xsl-nons
, fontconfig
, gdk-pixbuf
, gettext
, glib
, glib-networking
, gcr
, glibc
, gnome-bluetooth
, gnome-color-manager
, gnome-desktop
, gnome-online-accounts
, gnome-settings-daemon
, gnome-tecla
, gnome
, gsettings-desktop-schemas
, gsound
, gst_all_1
, gtk4
, ibus
, libgtop
, libgudev
, libadwaita
, libkrb5
, libpulseaudio
, libpwquality
, librsvg
, webp-pixbuf-loader
, libsecret
, libwacom
, libxml2
, libxslt
, meson
, modemmanager
, mutter
, networkmanager
, networkmanagerapplet
, libnma-gtk4
, ninja
, pkg-config
, polkit
, python3
, samba
, setxkbmap
, shadow
, shared-mime-info
, sound-theme-freedesktop
, tracker
, tracker-miners
, tzdata
, udisks2
, upower
, libepoxy
, gnome-user-share
, gnome-remote-desktop
, wrapGAppsHook
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-control-center";
  version = "45.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-control-center/${lib.versions.major finalAttrs.version}/gnome-control-center-${finalAttrs.version}.tar.xz";
    sha256 = "sha256-DPo8My1u2stz0GxrJv/KEHjob/WerIGbKTHglndT33A=";
  };

  patches = [
    (substituteAll {
      src = ./paths.patch;
      gcm = gnome-color-manager;
      inherit glibc tzdata shadow;
      inherit cups networkmanagerapplet;
    })
  ];

  nativeBuildInputs = [
    docbook-xsl-nons
    gettext
    libxslt
    meson
    ninja
    pkg-config
    python3
    shared-mime-info
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    adwaita-icon-theme
    colord
    colord-gtk4
    libepoxy
    fontconfig
    gdk-pixbuf
    glib
    glib-networking
    gcr
    gnome-bluetooth
    gnome-desktop
    gnome-online-accounts
    gnome-remote-desktop # optional, sharing panel
    gnome-settings-daemon
    gnome-tecla
    gnome-user-share # optional, sharing panel
    gsettings-desktop-schemas
    gsound
    gtk4
    ibus
    libgtop
    libgudev
    libadwaita
    libkrb5
    libnma-gtk4
    libpulseaudio
    libpwquality
    librsvg
    libsecret
    libwacom
    libxml2
    modemmanager
    mutter # schemas for the keybindings
    networkmanager
    polkit
    samba
    tracker
    tracker-miners # for search locations dialog
    udisks2
    upower
  ] ++ (with gst_all_1; [
    # For animations in Mouse panel.
    gst-plugins-base
    gst-plugins-good
  ]);

  nativeCheckInputs = [
    python3.pkgs.python-dbusmock
    setxkbmap
    xvfb-run
  ];

  doCheck = true;

  preConfigure = ''
    # For ITS rules
    addToSearchPath "XDG_DATA_DIRS" "${polkit.out}/share"
  '';

  checkPhase = ''
    runHook preCheck

    testEnvironment=(
      # Basically same as https://github.com/NixOS/nixpkgs/pull/141299
      "ADW_DISABLE_PORTAL=1"
      "XDG_DATA_DIRS=${glib.getSchemaDataDirPath gsettings-desktop-schemas}"
    )

    env "''${testEnvironment[@]}" xvfb-run \
      meson test --print-errorlogs

    runHook postCheck
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
      --prefix XDG_DATA_DIRS : "${sound-theme-freedesktop}/share"
      # Thumbnailers (for setting user profile pictures)
      --prefix XDG_DATA_DIRS : "${gdk-pixbuf}/share"
      --prefix XDG_DATA_DIRS : "${librsvg}/share"
      # WM keyboard shortcuts
      --prefix XDG_DATA_DIRS : "${mutter}/share"
    )
    for i in $out/share/applications/*; do
      substituteInPlace $i --replace "Exec=gnome-control-center" "Exec=$out/bin/gnome-control-center"
    done
  '';

  separateDebugInfo = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-control-center";
      attrPath = "gnome.gnome-control-center";
    };
  };

  meta = with lib; {
    description = "Utilities to configure the GNOME desktop";
    license = licenses.gpl2Plus;
    maintainers = teams.gnome.members;
    platforms = platforms.linux;
  };
})
