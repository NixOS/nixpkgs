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
  accountsservice,
  wayland-scanner,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "elementary-greeter";
  # To allow overriding last-session-type.
  # nixpkgs-update: no auto update
  version = "8.0.1-unstable-2025-09-14";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    rev = "2461ad1be4a4d0e541879abe869cf8911f505215";
    hash = "sha256-rDlaL2KCm0tz73cwHLgNAD7Ddbn1QFJVa+Syh5eTfWo=";
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
    accountsservice
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
    # Use NixOS default wallpaper
    substituteInPlace $out/etc/lightdm/io.elementary.greeter.conf \
      --replace "#default-wallpaper=/usr/share/backgrounds/elementaryos-default" \
      "default-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"

    substituteInPlace $out/share/xgreeters/io.elementary.greeter.desktop \
      --replace "Exec=io.elementary.greeter" "Exec=$out/bin/io.elementary.greeter"
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
