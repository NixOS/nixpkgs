{
  lib,
  stdenv,
  fetchurl,
  dpkg,
  autoPatchelfHook,
  writeShellScript,
  curl,
  jq,
  common-updater-scripts,
  fontconfig,
  freetype,
  icu,
  krb5,
  libGL,
  libice,
  libsm,
  libx11,
  libxcursor,
  libxext,
  libxi,
  libxkbcommon,
  libxrandr,
  libxrender,
  openssl,
}:

stdenv.mkDerivation {
  pname = "unifi-endpoint";
  version = "1.0.4-20";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://fw-download.ubnt.com/data/unifi-endpoint-desktop-app-deb/bed2-linux-1.0.4-20-ff164d14-a211-419d-9a04-43192d56a952.deb";
    hash = "sha256-5UNCzJxRTllGllfgYBSdRvc3G3/bLZ//HrNENIBDEfo=";
  };

  nativeBuildInputs = [
    dpkg
    autoPatchelfHook
  ];

  buildInputs = [
    fontconfig
    (lib.getLib stdenv.cc.cc)
  ];

  # Loaded with dlopen by the .NET runtime and Avalonia rather than linked.
  runtimeDependencies = [
    (lib.getLib freetype)
    (lib.getLib icu)
    (lib.getLib krb5)
    libGL
    libice
    libsm
    libx11
    libxcursor
    libxext
    libxi
    libxkbcommon
    libxrandr
    libxrender
    (lib.getLib openssl)
  ];

  # Self-contained single-file .NET executables: stripping corrupts the
  # appended bundle.
  dontStrip = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cp -r usr/lib usr/share $out/
    cp -r etc $out/etc

    # The daemon only talks to a GUI whose /proc/<pid>/exe is
    # /usr/lib/UniFi-Endpoint/UIDSTD.Avalonia, so the launcher must exec it
    # from there (the NixOS module bind-mounts this package at that path).
    mkdir -p $out/bin
    cat > $out/bin/unifi-endpoint <<EOF
    #!${stdenv.shell}
    exec /usr/lib/UniFi-Endpoint/UIDSTD.Avalonia "\$@"
    EOF
    chmod +x $out/bin/unifi-endpoint

    runHook postInstall
  '';

  passthru.updateScript = writeShellScript "update-unifi-endpoint" ''
    set -euo pipefail
    PATH=${
      lib.makeBinPath [
        curl
        jq
        common-updater-scripts
      ]
    }:$PATH
    url=$(curl -fsSL 'https://fw-update.ui.com/api/firmware-latest?filter=eq~~product~~unifi-endpoint-desktop-app-deb&filter=eq~~platform~~linux&filter=eq~~channel~~release' \
      | jq -r '._embedded.firmware[0]._links.data.href')
    version=$(sed -E 's|.*-linux-([0-9.]+-[0-9]+)-.*|\1|' <<< "$url")
    update-source-version unifi-endpoint "$version" "" "$url"
  '';

  meta = {
    description = "Ubiquiti UniFi Endpoint client for UniFi Identity VPN, WiFi and credential access";
    longDescription = ''
      UniFi Endpoint provides access to UniFi-managed networks, including
      VPN connectivity, WiFi authentication and credential management.

      The binaries expect to live at /usr/lib/UniFi-Endpoint; use the NixOS
      module `programs.unifi-endpoint.enable` rather than installing this
      package directly.
    '';
    homepage = "https://ui.com/download/app/identity-desktop";
    license = lib.licenses.unfree;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    maintainers = with lib.maintainers; [ kellanstevens ];
    mainProgram = "unifi-endpoint";
    platforms = [ "x86_64-linux" ];
  };
}
