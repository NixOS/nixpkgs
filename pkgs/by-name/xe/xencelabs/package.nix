{
  stdenv,
  lib,
  fetchzip,
  autoPatchelfHook,
  makeBinaryWrapper,
  libusb1,
  libx11,
  libxtst,
  libxrandr,
  xkeyboard-config,
  libGL,
  qt5,
}:
stdenv.mkDerivation rec {
  pname = "xencelabs";
  version = "1.3.4-26";

  src = fetchzip {
    url = "https://download01.xencelabs.com/file/20241225/Xencelabslinux_${version}.zip";
    sha256 = "sha256-FSxR7SekHqvvRXkNMcSpGumw8TTnRWGPP/N/rya1VOk=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    libusb1
    libx11
    libxtst
    libxrandr
    xkeyboard-config
    libGL
    qt5.qtbase
    qt5.qtsvg
  ];

  dontWrapQtApps = true;
  stripRoot = true;

  installPhase = ''
        runHook preInstall

        # unpack inner tarball from .zip archive.
        tar -xzf xencelabs-${version}.tar.gz

        mkdir -p $out/lib $out/bin $out/share

        # Copy application files.
        cp -r xencelabs-${version}/App/usr/lib/xencelabs $out/lib/
        cp -r xencelabs-${version}/App/usr/share/* $out/share/

        # Copy udev rules (NixOS handles linking to /etc automatically)
        mkdir -p $out/lib/udev/rules.d
        cp xencelabs-${version}/App/lib/udev/rules.d/10-xencelabs.rules $out/lib/udev/rules.d/

        # Create a modified start.sh script that fixes missing device configs.
        cat > $out/lib/xencelabs/start.sh <<'EOF'
    #!/usr/bin/env bash
    pkill xence 2>/dev/null || true

    appname=xencelabs
    dirname=$(dirname "$0")
    export LD_LIBRARY_PATH="$dirname/lib"

    USER_CONFIG="$HOME/.local/share/xencelabs"
    if [ ! -d "$USER_CONFIG" ]; then
        mkdir -p "$USER_CONFIG"
        cp -r "$dirname/config/." "$USER_CONFIG/"
    fi
    # Set the proper permissions for the config files regardless of if they were just created or not.
    setfacl -Rb "$USER_CONFIG"
    chown -R "$(id -u)":"$(id -g)" "$USER_CONFIG"
    find "$USER_CONFIG" -type d -exec chmod 755 {} +
    find "$USER_CONFIG" -type f -exec chmod 644 {} +

    lockfile="/tmp/qtsingleapp-Xencel-fb8d-lockfile"
    touch "$lockfile"
    chmod 777 "$lockfile"

    exec "$dirname/$appname" "$@"
    EOF

        # Set start script as executable.
        chmod +x $out/lib/xencelabs/start.sh

        # Fix desktop file to point to the proper directory rather than /lib.
        desktopFile="$out/share/applications/xencelabs.desktop"
        substituteInPlace "$desktopFile" \
          --replace-fail "/usr/lib/xencelabs/start.sh" "$out/bin/xencelabs" \
          --replace-fail "/usr/share/icons/xencelabs.png" "$out/share/icons/xencelabs.png"

        # Set the main binary executable.
        chmod +x $out/lib/xencelabs/xencelabs

        # Copy and modify the systemd service file.
        mkdir -p $out/lib/systemd/system
        cp xencelabs-${version}/App/etc/systemd/system/xencelabs.service $out/lib/systemd/system/
        substituteInPlace $out/lib/systemd/system/xencelabs.service \
          --replace-fail "/usr/lib/xencelabs/restar.sh" "$out/lib/xencelabs/restar.sh"

        # Copy and modify the restart script, but with the proper start for a Nix script.
        cp xencelabs-${version}/App/usr/lib/xencelabs/restar.sh $out/lib/xencelabs/restar.sh
        substituteInPlace $out/lib/xencelabs/restar.sh \
          --replace-fail "#!/bin/sh" "#!/usr/bin/env sh"
        substituteInPlace $out/lib/xencelabs/restar.sh \
          --replace-fail "sudo chmod" "chmod"
        chmod +x $out/lib/xencelabs/restar.sh

        runHook postInstall
  '';

  postInstall = ''
    makeBinaryWrapper \
      "$out/lib/xencelabs/start.sh" \
      "$out/bin/xencelabs" \
      --set LD_LIBRARY_PATH "$out/lib/xencelabs/lib" \
      --set QT_PLUGIN_PATH "$out/lib/xencelabs/platforms" \
      --set XDG_DATA_DIRS "$out/share" \
      --set QT_XKB_CONFIG_ROOT "${xkeyboardconfig}/share/X11/xkb"
  '';

  meta = with lib; {
    description = "Xencelabs tablet driver and control application";
    homepage = "https://www.xencelabs.com/us/support/download-drivers";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      naitrate
    ];
  };
}
