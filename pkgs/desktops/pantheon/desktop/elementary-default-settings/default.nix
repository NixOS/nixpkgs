{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
, pantheon
, meson
, ninja
, nixos-artwork
, glib
, pkg-config
, dbus
, polkit
, accountsservice
, python3
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
  version = "6.0.2";

  repoName = "default-settings";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "sha256-qaPj/Qp7RYzHgElFdM8bHV42oiPUbCMTC9Q+MUj4Q6Y=";
  };

  nativeBuildInputs = [
    accountsservice
    dbus
    glib # polkit requires
    meson
    ninja
    pkg-config
    polkit
    python3
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
    "-Dplank-dockitems=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  preInstall = ''
    # Install our override for plank dockitems as Appcenter is not ready to be preinstalled.
    # See: https://github.com/NixOS/nixpkgs/issues/70214.
    schema_dir=$out/share/glib-2.0/schemas
    install -D ${./overrides/plank-dockitems.gschema.override} $schema_dir/plank-dockitems.gschema.override

    # Our launchers that use paths at /run/current-system/sw/bin
    mkdir -p $out/etc/skel/.config/plank/dock1
    cp -avr ${./launchers} $out/etc/skel/.config/plank/dock1/launchers

    # Whitelist wingpanel indicators to be used in the greeter
    # https://github.com/elementary/greeter/blob/fc19752f147c62767cd2097c0c0c0fcce41e5873/debian/io.elementary.greeter.whitelist
    # wingpanel 2.3.2 renamed this to .allowed to .forbidden
    # https://github.com/elementary/wingpanel/pull/326
    install -D ${./io.elementary.greeter.allowed} $out/etc/wingpanel.d/io.elementary.greeter.allowed
  '';

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -rf $out/share/plymouth
    rm -rf $out/share/cups

    rm -rf $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  meta = with lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
