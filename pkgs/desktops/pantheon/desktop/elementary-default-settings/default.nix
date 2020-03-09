{ stdenv
, fetchFromGitHub
, pantheon
, meson
, ninja
, nixos-artwork
, glib
, pkgconfig
, dbus
, polkit
, accountsservice
, python3
}:

stdenv.mkDerivation rec {
  pname = "elementary-default-settings";
  version = "5.1.2";

  repoName = "default-settings";

  src = fetchFromGitHub {
    owner = "elementary";
    repo = repoName;
    rev = version;
    sha256 = "00z31alwn2skhksrhp2jk75f6jlaipzk91hclx7na4gbcyrw7ahw";
  };

  passthru = {
    updateScript = pantheon.updateScript {
      attrPath = "pantheon.${pname}";
    };
  };

  patches = [
    # https://github.com/elementary/default-settings/pull/119
    ./0001-Build-with-Meson.patch
  ];

  nativeBuildInputs = [
    accountsservice
    dbus
    glib # polkit requires
    meson
    ninja
    pkgconfig
    polkit
    python3
  ];

  mesonFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray}/share/artwork/gnome/nix-wallpaper-simple-dark-gray.png"
    "-Dplank-dockitems=false"
  ];

  postPatch = ''
    chmod +x meson/post_install.py
    patchShebangs meson/post_install.py
  '';

  preInstall = ''
    # Install our override for plank dockitems.
    # This is because we don't have Pantheon's mail or Appcenter.
    # See: https://github.com/NixOS/nixpkgs/issues/58161
    schema_dir=$out/share/glib-2.0/schemas
    install -D ${./overrides/plank-dockitems.gschema.override} $schema_dir/plank-dockitems.gschema.override

    # Our launchers that use paths at /run/current-system/sw/bin
    mkdir -p $out/etc/skel/.config/plank/dock1
    cp -avr ${./launchers} $out/etc/skel/.config/plank/dock1/launchers

    # Whitelist wingpanel indicators to be used in the greeter
    # TODO: is this needed or installed upstream?
    install -D ${./io.elementary.greeter.whitelist} $out/etc/wingpanel.d/io.elementary.greeter.whitelist
  '';

  postFixup = ''
    # https://github.com/elementary/default-settings/issues/55
    rm -rf $out/share/plymouth
    rm -rf $out/share/cups

    rm -rf $out/share/applications
  '';

  meta = with stdenv.lib; {
    description = "Default settings and configuration files for elementary";
    homepage = https://github.com/elementary/default-settings;
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
