{
  lib,
  stdenvNoCC,
  fetchurl,
  xar,
  cpio,
  rcodesign,
  writeShellApplication,
  curl,
  jq,
  common-updater-scripts,
  dpkg,
  autoPatchelfHook,
  wrapGAppsHook3,
  glib-networking,
  gtk3,
  glib,
  cairo,
  pango,
  gdk-pixbuf,
  libsoup_3,
  webkitgtk_4_1,
  libayatana-appindicator,
  net-tools,
  iw,
  openresolv,
  wirelesstools,
  networkmanager,
  gawk,
}:

let
  inherit (stdenvNoCC.hostPlatform) system;
  isLinux = stdenvNoCC.hostPlatform.isLinux;
  isDarwin = stdenvNoCC.hostPlatform.isDarwin;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "wifiman-desktop";
  version = "1.2.8";

  src = finalAttrs.passthru.sources.${system};

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs =
    lib.optionals isDarwin [
      xar
      cpio
      rcodesign
    ]
    ++ lib.optionals isLinux [
      dpkg
      autoPatchelfHook
      wrapGAppsHook3
    ];

  buildInputs = lib.optionals isLinux [
    gtk3
    glib
    cairo
    pango
    gdk-pixbuf
    libsoup_3
    webkitgtk_4_1
    glib-networking
  ];

  runtimeDependencies = lib.optionals isLinux [ libayatana-appindicator ];

  unpackPhase =
    if isLinux then
      ''
        runHook preUnpack

        dpkg-deb -x "$src" unpacked

        sourceRoot=unpacked
        runHook postUnpack
      ''
    else
      ''
        runHook preUnpack

        xar -xf "$src"

        mkdir app && (cd app && gzip -dc < ../WifimanDesktop.pkg/Payload | cpio -i)
        mkdir companion && (cd companion && gzip -dc < ../WiFimanNetworkHelper.pkg/Payload | cpio -i)

        find app companion -name '._*' -delete

        mv "companion/WiFiman Companion.app" "app/WiFiman Desktop.app/Contents/Resources/"

        sourceRoot=app
        runHook postUnpack
      '';

  dontConfigure = true;
  dontBuild = true;
  dontFixup = isDarwin;
  dontAutoPatchelf = isLinux;

  installPhase =
    if isLinux then
      ''
        runHook preInstall

        mkdir -p "$out/bin" "$out/lib" "$out/share/applications" "$out/lib/systemd/system"

        cp usr/bin/wifiman-desktop "$out/bin/"
        cp -R usr/lib/wifiman-desktop "$out/lib/"
        cp usr/share/applications/wifiman-desktop.desktop "$out/share/applications/"
        cp -R usr/share/icons "$out/share/"

        substituteInPlace usr/lib/wifiman-desktop/wifiman-desktop.service \
          --replace-fail '"/usr/lib/wifiman-desktop/wifiman-desktopd"' "\"$out/lib/wifiman-desktop/wifiman-desktopd\""
        cp usr/lib/wifiman-desktop/wifiman-desktop.service "$out/lib/systemd/system/"

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p "$out/Applications"
        cp -R "WiFiman Desktop.app" "$out/Applications/"

        rcodesign sign "$out/Applications/WiFiman Desktop.app/Contents/Resources/WiFiman Companion.app"
        rcodesign sign "$out/Applications/WiFiman Desktop.app"

        runHook postInstall
      '';

  preFixup = lib.optionalString isLinux ''
    gappsWrapperArgs+=(--prefix PATH : ${
      lib.makeBinPath [
        net-tools
        iw
        wirelesstools
        networkmanager
        gawk
        openresolv
      ]
    })
  '';

  postFixup = lib.optionalString isLinux ''
    autoPatchelf -- "$out/bin"

    for bin in "$out/lib/wifiman-desktop"/{wifiman-desktopd,wg,wireguard-go}; do
      patchelf --set-interpreter "$(< "$NIX_BINTOOLS/nix-support/dynamic-linker")" "$bin"
    done
  '';

  passthru = {
    sources = {
      aarch64-darwin = fetchurl {
        url = "https://desktop.wifiman.com/wifiman-desktop-${finalAttrs.version}-arm64.pkg";
        hash = "sha256-To9RqgISIieoyTupquagqnc4cBoKDiMSSHh8JjGewBE=";
      };

      x86_64-darwin = fetchurl {
        url = "https://desktop.wifiman.com/wifiman-desktop-${finalAttrs.version}-amd64.pkg";
        hash = "sha256-wPkP+Kfs30haFii3AjWjshCDohLhiNprlB5Euk6a//w=";
      };

      x86_64-linux = fetchurl {
        url = "https://desktop.wifiman.com/wifiman-desktop-${finalAttrs.version}-amd64.deb";
        hash = "sha256-R+MbwxfnBV9VcYWeM1NM08LX1Mz9+fy4r6uZILydlks=";
      };
    };

    updateScript = writeShellApplication {
      name = "update-wifiman-desktop";
      runtimeInputs = [
        curl
        jq
        common-updater-scripts
      ];
      text = ''
        manifest="$(curl --fail --silent --show-error https://desktop.wifiman.com/wifiman-desktop-macos-manifest.json)"

        new_version="$(jq --exit-status --raw-output '.version' <<< "$manifest")"

        if [[ "${finalAttrs.version}" == "$new_version" ]]; then
          echo "The new version is the same as the old version."
          exit 0
        fi

        for platform in ${lib.escapeShellArgs (builtins.attrNames finalAttrs.passthru.sources)}; do
          update-source-version "${finalAttrs.pname}" "$new_version" --ignore-same-version --source-key="sources.$platform"
        done
      '';
    };
  };

  meta = {
    description = "Scan, analyze and optimize nearby wireless networks (Ubiquiti WiFiman Desktop)";
    longDescription = ''
      WiFiman Desktop is a powerful wireless network analysis and optimization tool
      developed by Ubiquiti. Designed for network administrators, IT professionals,
      and enthusiasts, it provides real-time visibility into Wi-Fi network performance
      and environmental coverage.

      Key features include:
      - Continuous Wi-Fi scanning to detect nearby Access Points (APs), signal strength (RSSI),
        and channel utilization.
      - Integrated speed testing and latency monitoring to evaluate local network performance
        and internet connectivity.
      - Detailed device discovery across local subnets to identify connected network clients,
        IP addresses, MAC addresses, and vendor details.
      - Seamless integration with Ubiquiti UniFi network deployments for enhanced telemetry
        and seamless remote connection options (such as Teleport VPN).
    '';
    homepage = "https://wifiman.com/";
    downloadPage = "https://ui.com/download/app/wifiman-desktop";
    license = lib.licenses.unfree;
    platforms = lib.platforms.darwin ++ [ "x86_64-linux" ];
    mainProgram = "wifiman-desktop";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        part = "a";
        vendor = "ui";
        product = "wifiman_desktop";
        version = finalAttrs.version;
      };
      purlParts = {
        type = "generic";
        spec = "ubiquiti/wifiman-desktop@${finalAttrs.version}";
      };
    };
    maintainers = with lib.maintainers; [ KristijanZic ];
  };
})
