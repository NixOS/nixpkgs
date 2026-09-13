{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  alsa-lib,
  at-spi2-atk,
  at-spi2-core,
  atk,
  cairo,
  cups,
  dbus-glib,
  libnotify,
  libdrm,
  libxkbcommon,
  mesa,
  nspr,
  nss,
  pango,
  systemd,
  libpulseaudio,
  gdk-pixbuf,
  gtk3,
  makeDesktopItem,
  unzip,
  libX11,
  libXScrnSaver,
  libXcomposite,
  libXcursor,
  libXdamage,
  libXext,
  libXfixes,
  libXi,
  libXrandr,
  libXrender,
  libXtst,
  libxcb,
  writeText,
  patchelf,
  makeWrapper,
  libGL,
  ffmpeg,
  glib,
  pciutils,
}:

let
  version = "6.5.6";

  desktopItem = makeDesktopItem {
    name = "waterfox";
    exec = "waterfox %U";
    icon = "waterfox";
    desktopName = "Waterfox";
    genericName = "Web Browser";
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  prefsFile = writeText "waterfox-prefs.js" ''
    // Disable automatic updates and notifications
    pref("app.update.auto", false);
    pref("app.update.enabled", false);
    pref("browser.crashReports.unsubmittedCheck.enabled", false);
  '';

in
stdenv.mkDerivation (finalAttrs: {
  pname = "waterfox";
  inherit version;

  src = fetchurl {
    url = "https://cdn1.waterfox.net/waterfox/releases/${finalAttrs.version}/Linux_x86_64/waterfox-${finalAttrs.version}.tar.bz2";
    hash = "sha256-lODOZQ980Af8mF8Pyd8YZ5ENkBhJwrBEE1KhPGEePUI=";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    unzip
    patchelf
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    dbus-glib
    libnotify
    libdrm
    libxkbcommon
    mesa
    nspr
    nss
    pango
    systemd
    libpulseaudio
    gdk-pixbuf
    gtk3
    libX11
    libXScrnSaver
    libXcomposite
    libXcursor
    libXdamage
    libXext
    libXfixes
    libXi
    libXrandr
    libXrender
    libXtst
    libxcb
    stdenv.cc.cc.lib
    libGL
    ffmpeg
    glib
    pciutils
  ];

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/{bin,opt,share/applications}
    cp -r . $out/opt/waterfox

    makeWrapper $out/opt/waterfox/waterfox-bin $out/bin/waterfox \
      --set GTK_IM_MODULE gtk-im-context-simple \
      --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath finalAttrs.buildInputs}"

    cp ${desktopItem}/share/applications/* $out/share/applications/

    mkdir -p $out/share/icons/hicolor/256x256/apps
    cp $out/opt/waterfox/browser/chrome/icons/default/default256.png \
      $out/share/icons/hicolor/256x256/apps/waterfox.png

    mkdir -p $out/opt/waterfox/browser/defaults/preferences
    cp ${prefsFile} $out/opt/waterfox/browser/defaults/preferences/nix-prefs.js

    runHook postInstall
  '';

  postInstall = ''
    find $out/opt/waterfox -type f -name "*.so" -exec sh -c '
      if patchelf --print-interpreter "{}" >/dev/null 2>&1; then
        patchelf \
          --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/waterfox" \
          "{}"
      fi
    ' \;

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/waterfox-bin

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/glxtest

    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${lib.makeLibraryPath finalAttrs.buildInputs}:$out/opt/waterfox" \
      $out/opt/waterfox/vaapitest

    cp -L ${nspr}/lib/libnspr4.so $out/opt/waterfox/
    cp -L ${nspr}/lib/libplc4.so $out/opt/waterfox/
    cp -L ${nspr}/lib/libplds4.so $out/opt/waterfox/

    for lib in ${nss}/lib/lib{nss3,nssutil3,smime3,ssl3}.so; do
      if [ ! -e $out/opt/waterfox/$(basename $lib) ]; then
        cp -L $lib $out/opt/waterfox/
      fi
    done
  '';

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:$out/share"
    )
  '';

  meta = {
    description = "Privacy-focused, multi-platform web browser";
    homepage = "https://www.waterfox.net/";
    downloadPage = "https://github.com/BrowserWorks/Waterfox";
    changelog = "https://github.com/BrowserWorks/Waterfox/releases/tag/${version}";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      joyfulcat
    ];
  };
})
