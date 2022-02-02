{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
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
, mutter
, elementary-icon-theme
, wingpanel-with-indicators
, elementary-gtk-theme
, nixos-artwork
, lightdm
, gdk-pixbuf
, clutter-gtk
, dbus
, accountsservice
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-greeter";
  version = "6.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "greeter";
    rev = version;
    sha256 = "1f606ds56sp1c58q8dblfpaq9pwwkqw9i4gkwksw45m2xkwlbflq";
  };

  patches = [
    ./sysconfdir-install.patch
    # Needed until https://github.com/elementary/greeter/issues/360 is fixed
    (substituteAll {
      src = ./hardcode-fallback-background.patch;
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })
    # Revert "UserCard: use accent color for logged_in check (#566)"
    # https://github.com/elementary/greeter/pull/566
    # Fixes crash issue reported in:
    # https://github.com/elementary/greeter/issues/578
    # https://github.com/NixOS/nixpkgs/issues/151609
    # Probably also fixes:
    # https://github.com/elementary/greeter/issues/568
    # https://github.com/elementary/greeter/issues/583
    # https://github.com/NixOS/nixpkgs/issues/140513
    # Revisit this when the greeter is ported to GTK 4:
    # https://github.com/elementary/greeter/pull/591
    ./revert-pr566.patch
    # Fix build with meson 0.61
    # https://github.com/elementary/greeter/pull/590
    (fetchpatch {
      url = "https://github.com/elementary/greeter/commit/a4b25244058fce794a9f13f6b22a8ff7735ebde9.patch";
      sha256 = "sha256-qPXhdvmYG8YMDU/CjbEkfZ0glgRzxnu0TsOPtvWHxLY=";
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
    clutter-gtk # else we get could not generate cargs for mutter-clutter-2
    elementary-gtk-theme
    elementary-icon-theme
    gnome-settings-daemon
    gdk-pixbuf
    granite
    gtk3
    libgee
    libhandy
    lightdm
    mutter
    wingpanel-with-indicators
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

      # the theme is hardcoded
      --prefix XDG_DATA_DIRS : "${elementary-gtk-theme}/share"
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
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };

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
