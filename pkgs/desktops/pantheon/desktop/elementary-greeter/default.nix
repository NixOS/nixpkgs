{ lib, stdenv
, fetchFromGitHub
, fetchpatch
, nix-update-script
, linkFarm
, substituteAll
, elementary-greeter
, pantheon
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
, elementary-settings-daemon
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
  version = "6.0.0";

  repoName = "greeter";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "1ny1003bbpdscc4kr2d94zc5vxm30y64dpj3fpd5zz2p2g0cq2h9";
  };

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };

    xgreeters = linkFarm "pantheon-greeter-xgreeters" [{
      path = "${elementary-greeter}/share/xgreeters/io.elementary.greeter.desktop";
      name = "io.elementary.greeter.desktop";
    }];
  };

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
    elementary-settings-daemon
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

  patches = [
    # Upstream code not respecting our localedir
    # https://github.com/elementary/greeter/pull/545
    (fetchpatch {
      url = "https://github.com/elementary/greeter/commit/d1373a7db827bc753bfcd70d0c8f25460ea9f1de.patch";
      sha256 = "0s8l7ycd2s307d3dh1p4vdk33dbzjzqwxs6msyb9w0ycfyxlwdvp";
    })
    ./sysconfdir-install.patch
    # Needed until https://github.com/elementary/greeter/issues/360 is fixed
    (substituteAll {
      src = ./hardcode-fallback-background.patch;
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}";
    })
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # dbus-launch needed in path
      --prefix PATH : "${dbus}/bin"

      # for `wingpanel -g`
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

  meta = with lib; {
    description = "LightDM Greeter for Pantheon";
    homepage = "https://github.com/elementary/greeter";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
