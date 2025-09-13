{
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  makeDesktopItem,
  alsa-lib,
  atk,
  cairo,
  dbus-glib,
  firefox-esr,
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  nspr,
  nss,
  xorg,
  libgbm,
  pango,
  pciutils,
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "7.1-beta.41+355c61e6d";

  src =
    let
      escapedVersion = lib.escapeURL version;
    in
    fetchurl {
      url = "https://download.zotero.org/client/beta/${escapedVersion}/Zotero-${escapedVersion}_linux-x86_64.tar.bz2";
      hash = "sha256-0eJYXBabYh8n1SHSy7j+jIkY9jMuxKhtieJy6Ewwpug=";
    };

  dontPatchELF = true;
  nativeBuildInputs = [ wrapGAppsHook3 ];

  libPath =
    lib.makeLibraryPath [
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
      libgbm
      pango
      pciutils
    ]
    + ":"
    + lib.makeSearchPathOutput "lib" "lib" [ stdenv.cc.cc ];

  desktopItem = makeDesktopItem {
    name = "zotero";
    exec = "zotero -url %U";
    icon = "zotero";
    comment = meta.description;
    desktopName = "Zotero";
    genericName = "Reference Management";
    categories = [
      "Office"
      "Database"
    ];
    startupNotify = true;
    mimeTypes = [
      "x-scheme-handler/zotero"
      "text/plain"
    ];
  };

  installPhase = ''
    runHook preInstall

    pkg_dir="$prefix/usr/lib/zotero-bin-${version}"

    # Copy package contents to the output directory
    mkdir -p "$pkg_dir"
    cp -r * "$pkg_dir"

    ln -sf ${nss}/lib/libfreeblpriv3.so "$pkg_dir/libfreeblpriv3.so"
    ln -sf ${firefox-esr}/lib/firefox/libgkcodecs.so "$pkg_dir/libgkcodecs.so"
    ln -sf ${firefox-esr}/lib/firefox/libmozsqlite3.so "$pkg_dir/libmozsqlite3.so"
    ln -sf ${nspr}/lib/libnspr4.so "$pkg_dir/libnspr4.so"
    ln -sf ${nss}/lib/libnss3.so "$pkg_dir/libnss3.so"
    ln -sf ${nss}/lib/libnssckbi.so "$pkg_dir/libnssckbi.so"
    ln -sf ${nss}/lib/libnssutil3.so "$pkg_dir/libnssutil3.so"
    ln -sf ${nss}/lib/libsoftokn3.so "$pkg_dir/libsoftokn3.so"
    ln -sf ${nss}/lib/libssl3.so "$pkg_dir/libssl3.so"
    ln -sf ${firefox-esr}/lib/firefox/libxul.so "$pkg_dir/libxul.so"

    mkdir -p "$out/bin"
    ln -s "$pkg_dir/zotero" "$out/bin/"

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

  meta = {
    homepage = "https://www.zotero.org";
    downloadPage = "https://www.zotero.org/support/beta_builds";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
    ];
  };
}
