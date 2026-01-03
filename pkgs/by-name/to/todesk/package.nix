{
  stdenv,
  lib,
  procps,
  fetchurl,
  dpkg,
  writeShellScript,
  buildFHSEnv,
  nspr,
  kmod,
  systemdMinimal,
  glib,
  pulseaudio,
  libXext,
  libX11,
  libXrandr,
  glibc,
  cairo,
  libva,
  libdrm,
  coreutils,
  libXi,
  libGL,
  bash,
  libXcomposite,
  libXdamage,
  libXfixes,
  libXtst,
  nss,
  libXxf86vm,
  gtk3,
  gdk-pixbuf,
  pango,
  libz,
  libayatana-appindicator,
}:

let
  version = "4.7.2.0";
  todesk-unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "todesk-unwrapped";
    version = version;
    src = fetchurl {
      url = "https://web.archive.org/web/20250302114501if_/https://newdl.todesk.com/linux/todesk-v4.7.2.0-amd64.deb";
      hash = "sha256-v7VpXXFVaKI99RpzUWfAc6eE7NHGJeFrNeUTbVuX+yg=";
    };
    nativeBuildInputs = [ dpkg ];

    unpackPhase = ''
      runHook preUnpack
      dpkg -x $src ./todesk-src
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/lib"
      cp -r todesk-src/* "$out"
      cp "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1" "$out/opt/todesk/bin/libappindicator3.so.1"
      mv "$out/opt/todesk/bin" "$out/bin"
      cp "$out/bin/libmfx.so.1" "$out/lib"
      cp "$out/bin/libglut.so.3" "$out/lib"
      mkdir "$out/opt/todesk/config"
      mkdir "$out/opt/todesk/bin"
      mkdir -p "$out/share/applications"
      mkdir "$out/share/icons"
      runHook postInstall
    '';

  });

in
buildFHSEnv {
  inherit version;
  pname = "todesk";
  targetPkgs = pkgs: [
    todesk-unwrapped
    pulseaudio
    nspr
    kmod
    libXi
    systemdMinimal
    glib
    libz
    bash
    coreutils
    libX11
    libXext
    libXrandr
    glibc
    libdrm
    libGL
    procps
    cairo
    libXcomposite
    libXdamage
    libXfixes
    libXtst
    nss
    libXxf86vm
    gtk3
    gdk-pixbuf
    pango
    libva
  ];
  extraBwrapArgs = [
    "--tmpfs /opt/todesk"
    "--bind /var/lib/todesk /opt/todesk/config" # create the folder before bind to avoid permission denided.
    "--bind ${todesk-unwrapped}/bin /opt/todesk/bin"
    "--bind /var/lib/todesk /etc/todesk" # service write uuid here. Such a pain!
  ]; # soft link doesn't work so that we should bind ourselves
  runScript = writeShellScript "ToDesk.sh" ''
    export LIBVA_DRIVER_NAME=iHD
    export LIBVA_DRIVERS_PATH=${todesk-unwrapped}/bin
    if [ "''${1}" = 'service' ]
    then
        /opt/todesk/bin/ToDesk_Service
    else
        /opt/todesk/bin/ToDesk
    fi
  ''; # a small script to choose what to exec
  extraInstallCommands = ''
    mkdir -p "$out/share/applications"
    mkdir -p "$out/share/icons"
    cp ${todesk-unwrapped}/usr/share/applications/todesk.desktop $out/share/applications
    cp -rf ${todesk-unwrapped}/usr/share/icons/* $out/share/icons
    substituteInPlace "$out/share/applications/todesk.desktop" \
      --replace-fail '/opt/todesk/bin/ToDesk' "$out/bin/todesk desktop"
    substituteInPlace "$out/share/applications/todesk.desktop" \
      --replace-fail '/opt/todesk/bin' "${todesk-unwrapped}/lib"
  '';
  meta = {
    description = "Remote Desktop Application";
    homepage = "https://www.todesk.com/linux.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    mainProgram = "todesk";
  };
}
