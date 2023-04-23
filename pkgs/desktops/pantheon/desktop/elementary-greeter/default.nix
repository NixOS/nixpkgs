{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, linkFarm
, substituteAll
, elementary-greeter
, pkg-config
, meson
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, libgee
, libhandy
, gnome-settings-daemon
, mesa
, mutter
, elementary-icon-theme
, wingpanel-with-indicators
, elementary-gtk-theme
, nixos-artwork
, lightdm
, gdk-pixbuf
, dbus
, accountsservice
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-greeter";
  version = "6.1.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    rev = version;
    sha256 = "sha256-6rjZOX9JOTjZwqWVWTtKjGNy8KgWllE9VQZzwhuBAwE=";
  };

  patches = [
    ./sysconfdir-install.patch
    # Needed until https://github.com/elementary/greeter/issues/360 is fixed
    (substituteAll {
      src = ./hardcode-fallback-background.patch;
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })
  ];

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    elementary-icon-theme
    gnome-settings-daemon
    gdk-pixbuf
    granite
    gtk3
    libgee
    libhandy
    lightdm
    mesa # for libEGL
    mutter
  ];

  mesonFlags = [
    # A hook does this but after wrapGAppsHook so the files never get wrapped.
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

    xgreeters = linkFarm "pantheon-greeter-xgreeters" [{
      path = "${elementary-greeter}/share/xgreeters/io.elementary.greeter.desktop";
      name = "io.elementary.greeter.desktop";
    }];
  };

  meta = with lib; {
    description = "LightDM Greeter for Pantheon";
    homepage = "https://github.com/elementary/greeter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
    mainProgram = "io.elementary.greeter";
  };
}
