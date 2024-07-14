{ lib
, stdenv
, fetchurl
, wrapGAppsHook3
, makeDesktopItem
, alsa-lib
, atk
, cairo
, dbus-glib
, gdk-pixbuf
, glib
, gtk3
, libGL
, xorg
, mesa
, pango
, pciutils
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "7.0.0-beta.83+066eda731";

  src =
    let
      escapedVersion = lib.replaceStrings ["+"] ["%2B"] version;
    in
    fetchurl {
      url = "https://download.zotero.org/client/beta/${escapedVersion}/Zotero-${escapedVersion}_linux-x86_64.tar.bz2";
      hash = "sha256-wqew12/Icv4XS+IJRVcf1Rh/ipqBhe8QGkP8ErfS4J0=";
    };

  dontPatchELF = true;
  nativeBuildInputs = [ wrapGAppsHook3 ];

  libPath = lib.makeLibraryPath [
    alsa-lib
    atk
    cairo
    dbus-glib
    gdk-pixbuf
    glib
    gtk3
    libGL
    xorg.libX11
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXtst
    xorg.libxcb
    mesa
    pango
    pciutils
  ] + ":" + lib.makeSearchPathOutput "lib" "lib64" [ stdenv.cc.cc ];

  desktopItem = makeDesktopItem {
    name = "zotero";
    exec = "zotero -url %U";
    icon = "zotero";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = [ "Office" "Database" ];
    startupNotify = true;
    mimeTypes = [ "x-scheme-handler/zotero" "text/plain" ];
  };

  installPhase = ''
    runHook preInstall

    # Copy package contents to the output directory
    mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
    cp -r * "$prefix/usr/lib/zotero-bin-${version}"
    mkdir -p "$out/bin"
    ln -s "$prefix/usr/lib/zotero-bin-${version}/zotero" "$out/bin/"

    # Install desktop file and icons
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications/
    for size in 32 64 128; do
      install -Dm444 icons/icon''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done
    install -Dm444 icons/symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/zotero-symbolic.svg

    runHook postInstall
  '';

  postFixup = ''
    for executable in \
      zotero-bin plugin-container updater vaapitest \
      minidump-analyzer glxtest
    do
      if [ -e "$out/usr/lib/zotero-bin-${version}/$executable" ]; then
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$out/usr/lib/zotero-bin-${version}/$executable"
      fi
    done
    find . -executable -type f -exec \
      patchelf --set-rpath "$libPath" \
        "$out/usr/lib/zotero-bin-${version}/{}" \;
  '';

  meta = with lib; {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ atila justanotherariel ];
  };
}
