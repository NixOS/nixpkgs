{
  stdenv,
  lib,
  fetchurl,
  dpkg,
  writeShellScript,
  buildFHSEnv,
  nspr,
  kmod,
  systemdMinimal,
  glib,
  pulseaudio,
  libxext,
  libx11,
  libxrandr,
  cairo,
  libva,
  libgbm,
  libpng,
  libxcb,
  libxcb-util,
  libxcb-keysyms,
  libxcb-wm,
  libdrm,
  libxi,
  libGL,
  libxcomposite,
  libxdamage,
  libxfixes,
  libxtst,
  nss,
  libxxf86vm,
  gtk3,
  gdk-pixbuf,
  pango,
  libz,
  libayatana-appindicator,
}:

let
  version = "4.9.6.0";
  todesk-unwrapped = stdenv.mkDerivation (finalAttrs: {
    pname = "todesk-unwrapped";
    version = version;
    src = fetchurl {
      url = "https://web.archive.org/web/20260908130616if_/https://dl.todesk.com/linux/todesk-v4.9.6.0-amd64.deb";
      hash = "sha256-t+KgiUmW7k40/LPd+zlpLHKUPAWxM6c69J9IBD19rBY=";
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
      cp "$out/bin/libzulerLog.so" "$out/lib"
      cp "$out/bin/libigdgmm.so.12" "$out/lib"
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
    libxi
    systemdMinimal
    glib
    libz
    libx11
    libxext
    libxrandr
    libdrm
    libGL
    cairo
    libxcomposite
    libxdamage
    libxfixes
    libxtst
    nss
    libxxf86vm
    gtk3
    gdk-pixbuf
    pango
    libva
    libgbm
    libpng
    libxcb
    libxcb-util
    libxcb-keysyms
    libxcb-wm
  ];
  extraBwrapArgs = [
    "--tmpfs /opt/todesk"
    # /var/lib/todesk must already exist: bwrap treats a missing --bind source
    # as a fatal error. On NixOS, services.todesk creates it via StateDirectory.
    "--bind /var/lib/todesk /opt/todesk/config"
    "--bind ${todesk-unwrapped}/bin /opt/todesk/bin"
    "--bind /var/lib/todesk /etc/todesk" # service write uuid here. Such a pain!
  ]; # soft link doesn't work so that we should bind ourselves
  runScript = writeShellScript "ToDesk.sh" ''
    export LIBVA_DRIVER_NAME=iHD
    export LIBVA_DRIVERS_PATH=${todesk-unwrapped}/bin
    export GDK_BACKEND=x11
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
