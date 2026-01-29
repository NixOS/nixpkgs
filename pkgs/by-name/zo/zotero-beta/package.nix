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
  gdk-pixbuf,
  glib,
  gtk3,
  libGL,
  libxtst,
  libxrandr,
  libxi,
  libxfixes,
  libxext,
  libxdamage,
  libxcursor,
  libxcomposite,
  libx11,
  libxcb,
  libgbm,
  pango,
  pciutils,
  firefox-esr,
  nspr,
  nss,
}:

stdenv.mkDerivation rec {
  pname = "zotero";
  version = "8.0-beta.20+1233fd5a7";

  src =
    let
      inherit (stdenv.hostPlatform) system linuxArch;
      escapedVersion = lib.escapeURL version;
      platformHash = {
        x86_64-linux = "sha256-IV8pukYHlGOL4bInbdh1SqKjlItum4LY7SRE+v73Spk=";
        aarch64-linux = "sha256-+V1XtmpI7ye37oba9nNTBOC+D9+V3ag1y+SYabXfxpQ=";
      };
      throwSystem = throw "Unsupported system: ${system}";
    in
    fetchurl {
      url = "https://download.zotero.org/client/beta/${escapedVersion}/Zotero-${escapedVersion}_linux-${linuxArch}.tar.xz";
      hash = platformHash.${system} or throwSystem;
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
      libx11
      libxcomposite
      libxcursor
      libxdamage
      libxext
      libxfixes
      libxi
      libxrandr
      libxtst
      libxcb
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

    # Copy package contents to the output directory
    mkdir -p "$prefix/usr/lib/zotero-bin-${version}"
    cp -r * "$prefix/usr/lib/zotero-bin-${version}"

    # Replace bundled shared libraries with system-provided ones
    for path in ${firefox-esr}/lib/firefox ${nspr}/lib ${nss}/lib; do
      for lib in "$path"/*.so; do
        name="$(basename "$lib")"
        if [ -f $lib ] && [ -f "$prefix/usr/lib/zotero-bin-${version}/$name" ]; then
          ln -sf "$lib" "$prefix/usr/lib/zotero-bin-${version}/$name"
        fi
      done
    done

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
    find . -executable -type f -exec \
      patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        "$out/usr/lib/zotero-bin-${version}/{}" \
        --set-rpath "$libPath" \;

    patchelf --add-needed libGL.so.1 --add-needed libEGL.so.1 \
      "$out/usr/lib/zotero-bin-${version}/zotero-bin"

    makeWrapper $out/usr/lib/zotero-bin-${version}/zotero $out/bin/zotero \
      ''${gappsWrapperArgs[@]}
  '';

  meta = {
    homepage = "https://www.zotero.org";
    description = "Collect, organize, cite, and share your research sources";
    mainProgram = "zotero";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.agpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with lib.maintainers; [
      atila
      justanotherariel
    ];
  };
}
