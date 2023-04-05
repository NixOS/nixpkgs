{ lib
, stdenv
, fetchFromGitHub
, nix-update-script
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
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = "default-settings";
    rev = version;
    sha256 = "sha256-RPnERK93GCfWyw1sIW5BitCIo11/t1koV4r1+NF5NdI=";
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
    # Install our override for plank dockitems as the desktop file path is different.
    schema_dir=$out/share/glib-2.0/schemas
    install -D ${./overrides/plank-dockitems.gschema.override} $schema_dir/plank-dockitems.gschema.override

    # Our launchers that use paths at /run/current-system/sw/bin
    mkdir -p $out/etc/skel/.config/plank/dock1
    cp -avr ${./launchers} $out/etc/skel/.config/plank/dock1/launchers
  '';

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -r $out/share/cups
    rm -r $out/share/applications
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = with lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.pantheon.members;
  };
}
