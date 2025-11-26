{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  linkFarm,
  replaceVars,
  elementary-greeter,
  pkg-config,
  meson,
  ninja,
  vala,
  desktop-file-utils,
  gtk3,
  granite,
  libgee,
  libhandy,
  gala,
  gnome-desktop,
  gnome-settings-daemon,
  mutter,
  elementary-icon-theme,
  elementary-settings-daemon,
  wingpanel-with-indicators,
  elementary-gtk-theme,
  nixos-artwork,
  lightdm,
  gdk-pixbuf,
  dbus,
  wayland-scanner,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-greeter";
  version = "8.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    tag = version;
    hash = "sha256-eoZ4WkIUesWTFipC6ji1QdU0dy9iMGCbQSkI74c0VRA=";
  };

  patches = [
    ./sysconfdir-install.patch
    # Needed until https://github.com/elementary/greeter/issues/360 is fixed
    (replaceVars ./hardcode-fallback-background.patch {
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })
  ];

  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    elementary-icon-theme
    elementary-settings-daemon
    gala # for io.elementary.desktop.background
    gnome-desktop
    gnome-settings-daemon
    gdk-pixbuf
    granite
    gtk3
    libgee
    libhandy
    lightdm
    mutter
  ];

  mesonFlags = [
    # A hook does this but after wrapGAppsHook3 so the files never get wrapped.
    "--sbindir=${placeholder "out"}/bin"
    # baked into the program for discovery of the greeter configuration
    "--sysconfdir=/etc"
    "-Dgsd-dir=${gnome-settings-daemon}/libexec/" # trailing slash is needed
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # dbus-launch needed in path
      --prefix PATH : "${dbus}/bin"

      # for `io.elementary.wingpanel -g`
      --prefix PATH : "${wingpanel-with-indicators}/bin"

      # for the compositor
      --prefix PATH : "$out/bin"

      # the GTK theme is hardcoded
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"

      # the icon theme is hardcoded
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS"
    )
  '';

  postFixup = ''
    substituteInPlace $out/share/xgreeters/io.elementary.greeter.desktop \
      --replace-fail "Exec=io.elementary.greeter" "Exec=$out/bin/io.elementary.greeter"
  '';

  passthru = {
    updateScript = nix-update-script { };

    xgreeters = linkFarm "pantheon-greeter-xgreeters" [
      {
        path = "${elementary-greeter}/share/xgreeters/io.elementary.greeter.desktop";
        name = "io.elementary.greeter.desktop";
      }
    ];
  };

  meta = with lib; {
    description = "LightDM Greeter for Pantheon";
    homepage = "https://github.com/elementary/greeter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    teams = [ teams.pantheon ];
    mainProgram = "io.elementary.greeter";
  };
}
