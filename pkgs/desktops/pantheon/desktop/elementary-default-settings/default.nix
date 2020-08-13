{ stdenv
, fetchFromGitHub
, nix-update-script
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
, fetchpatch
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
    updateScript = nix-update-script {
      attrPath = "pantheon.${pname}";
    };
  };

  patches = [
    # Use new notifications
    (fetchpatch {
      url = "https://github.com/elementary/default-settings/commit/0658bb75b9f49f58b35746d05fb6c4b811f125e9.patch";
      sha256 = "0wa7iq0vfp2av5v23w94a5844ddj4g48d4wk3yrp745dyrimg739";
    })

    # Fix media key syntax
    (fetchpatch {
      url = "https://github.com/elementary/default-settings/commit/332aefe1883be5dfe90920e165c39e331a53b2ea.patch";
      sha256 = "0ypcaga55pw58l30srq3ga1mhz2w6hkwanv41jjr6g3ia9jvq69n";
    })

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
    "-Ddefault-wallpaper=${nixos-artwork.wallpapers.simple-dark-gray.gnomeFilePath}"
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
    # hhttps://github.com/elementary/greeter/blob/fc19752f147c62767cd2097c0c0c0fcce41e5873/debian/io.elementary.greeter.whitelist
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

  meta = with stdenv.lib; {
    description = "Default settings and configuration files for elementary";
    homepage = "https://github.com/elementary/default-settings";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = pantheon.maintainers;
  };
}
