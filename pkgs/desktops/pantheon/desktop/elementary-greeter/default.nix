{ stdenv
, fetchFromGitHub
, linkFarm
, substituteAll
, elementary-greeter
, pantheon
, pkgconfig
, meson
, ninja
, vala
, desktop-file-utils
, gtk3
, granite
, libgee
, elementary-settings-daemon
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
  version = "5.0.2";

  repoName = "greeter";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "0557lr8czqwjrm39ykfacqw5x7nng7fmf1gxkif70xg7dk3lc7gd";
  };

  passthru = {
    updateScript = pantheon.updateScript {
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
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    clutter-gtk # else we get could not generate cargs for mutter-clutter-2
    elementary-gtk-theme
    elementary-icon-theme
    elementary-settings-daemon
    gdk-pixbuf
    granite
    gtk3
    libgee
    lightdm
    mutter
    wingpanel-with-indicators
  ];

  mesonFlags = [
    # A hook does this but after wrapGAppsHook so the files never get wrapped.
    "--sbindir=${placeholder "out"}/bin"
    # baked into the program for discovery of the greeter configuration
    "--sysconfdir=/etc"
    # We use the patched gnome-settings-daemon
    "-Dubuntu-patched-gsd=true"
    "-Dgsd-dir=${elementary-settings-daemon}/libexec/" # trailing slash is needed
  ];

  patches = [
    ./sysconfdir-install.patch
    # Needed until https://github.com/elementary/greeter/issues/360 is fixed
    (substituteAll {
      src = ./hardcode-fallback-background.patch;
      default_wallpaper = "${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png";
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
    )
  '';

  postFixup = ''
    # Use NixOS default wallpaper
    substituteInPlace $out/etc/lightdm/io.elementary.greeter.conf \
      --replace "#default-wallpaper=/usr/share/backgrounds/elementaryos-default" \
      "default-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png"

    substituteInPlace $out/share/xgreeters/io.elementary.greeter.desktop \
      --replace "Exec=io.elementary.greeter" "Exec=$out/bin/io.elementary.greeter"
  '';

  meta = with stdenv.lib; {
    description = "LightDM Greeter for Pantheon";
    homepage = https://github.com/elementary/greeter;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
