{ stdenv, fetchFromGitHub, pantheon, pkgconfig, substituteAll, makeWrapper, meson
, ninja, vala, desktop-file-utils, gtk3, granite, libgee, elementary-settings-daemon
, gnome-desktop, mutter, gobject-introspection, elementary-icon-theme, wingpanel-with-indicators
, elementary-gtk-theme, nixos-artwork, elementary-default-settings, lightdm, numlockx
, clutter-gtk, libGL, dbus, wrapGAppsHook }:

stdenv.mkDerivation rec {
  pname = "greeter";
  version = "3.3.1";

  name = "elementary-${pname}-${version}";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = pname;
    rev = version;
    sha256 = "1vkq4z0hrmvzv4sh2qkxjajdxcycd1zj97a3pc8n4yb858pqfyzc";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      repoName = pname;
      attrPath = "elementary-${pname}";
    };
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkgconfig
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    clutter-gtk
    elementary-icon-theme
    elementary-gtk-theme
    elementary-settings-daemon
    gnome-desktop
    granite
    gtk3
    libgee
    libGL
    lightdm
    mutter
    wingpanel-with-indicators
  ];

  patches = [
    (substituteAll {
      src = ./gsd.patch;
      elementary-settings-daemon = "${elementary-settings-daemon}/libexec";
    })
    (substituteAll {
      src = ./numlockx.patch;
      inherit numlockx;
    })
    ./01-sysconfdir-install.patch
  ];

  mesonFlags = [
    # A hook does this but after wrapGAppsHook so the files never get wrapped.
    "--sbindir=${placeholder "out"}/bin"
    # baked into the program for discovery of the greeter configuration
    "--sysconfdir=/etc"
  ];

  preFixup = ''
    gappsWrapperArgs+=(
      # GTK+ reads default settings (such as icons and themes) from elementary's settings.ini here
      --prefix XDG_CONFIG_DIRS : "${elementary-default-settings}/etc"

      # dbus-launch needed in path
      --prefix PATH : "${dbus}/bin"

      # for `wingpanel -g`
      --prefix PATH : "${wingpanel-with-indicators}/bin"

      # TODO: they should be using meson for this
      # See: https://github.com/elementary/greeter/blob/19c0730fded4e9ddec5a491f0e78f83c7c04eb59/src/PantheonGreeter.vala#L451
      --prefix PATH : "$out/bin"
    )
  '';

  postFixup = ''
    substituteInPlace $out/share/xgreeters/io.elementary.greeter.desktop \
      --replace  "Exec=io.elementary.greeter" "Exec=$out/bin/io.elementary.greeter"

    substituteInPlace $out/etc/lightdm/io.elementary.greeter.conf \
      --replace "#default-wallpaper=/usr/share/backgrounds/elementaryos-default" "default-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png"
  '';

  meta = with stdenv.lib; {
    description = "LightDM Greeter for Pantheon";
    homepage = https://github.com/elementary/greeter;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
