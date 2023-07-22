{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, meson
, ninja
, pkg-config
, python3
, vala
, accountsservice
, dbus
, desktop-file-utils
, fwupd
, geoclue2
, glib
, gobject-introspection
, gtk3
, granite
, libgee
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "elementary-settings-daemon";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "settings-daemon";
    rev = version;
    sha256 = "sha256-464caR36oSUhxCU0utP5eMYiiBekU6W4bVIbsUoiFRI=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    python3
    vala
    wrapGAppsHook
  ];

  buildInputs = [
    accountsservice
    dbus
    fwupd
    geoclue2
    glib
    gtk3
    granite
    libgee
    systemd
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py

    substituteInPlace data/io.elementary.settings-daemon.check-for-firmware-updates.service \
      --replace "/usr/bin/busctl" "${systemd}/bin/busctl"
  '';

  postInstall = ''
    # https://github.com/elementary/settings-daemon/pull/75
    mkdir -p $out/etc/xdg/autostart
    ln -s $out/share/applications/io.elementary.settings-daemon.desktop $out/etc/xdg/autostart/io.elementary.settings-daemon.desktop
  '';

  # https://github.com/elementary/settings-daemon/pull/74
  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Settings daemon for Pantheon";
    homepage = "https://github.com/elementary/settings-daemon";
    license = licenses.gpl3Plus;
    maintainers = teams.pantheon.members;
    platforms = platforms.linux;
    mainProgram = "io.elementary.settings-daemon";
  };
}
