{ stdenv
, fetchFromGitHub
, deepin
, nixos-icons
}:

stdenv.mkDerivation rec {
  pname = "deepin-desktop-base";
  version = "2020.07.31";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "1sk8sy9hbkncmqzi9j93ww6abavx7s1l2k4ix60kmrfx16lpliyx";
  };

  nativeBuildInputs = [
    deepin.setupHook
  ];

  buildInputs = [
    nixos-icons
  ];

  postPatch = ''
    searchHardCodedPaths

    fixPath $out /etc Makefile
    fixPath $out /usr Makefile
    fixPath $out /var Makefile
  '';

  postInstall = ''
    # Remove Deepin distro's lsb-release
    rm $out/etc/lsb-release

    # Don't override systemd timeouts
    rm -r $out/etc/systemd

    # Remove UOS logo
    # TODO: Fix reference to uos_logo.svg in share/deepin/dde-desktop-watermask.json
    rm $out/share/deepin/uos_logo.svg

    # Remove UOS license
    rm $out/var/uos/os-license
    rmdir $out/var/uos
    rmdir $out/var

    # Remove apt-specific templates
    rm -r $out/share/python-apt

    # Make a symlink for deepin-version
    ln -s ../lib/deepin/desktop-version $out/etc/deepin-version

    # Install distribution.info
    cat > $out/share/deepin/distribution.info <<EOF
    [Distribution]
    Name=NixOS
    WebsiteName=nixos.org
    Website=https://nixos.org
    Logo=${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg
    LogoLight=${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg
    LogoTransparent=${nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg
    EOF
  '';

  postFixup = ''
    searchHardCodedPaths $out  # debugging
  '';

  passthru.updateScript = deepin.updateScript { inherit pname version src; };

  meta = with stdenv.lib; {
    description = "Base assets and definitions for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/deepin-desktop-base";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ romildo ];
  };
}
