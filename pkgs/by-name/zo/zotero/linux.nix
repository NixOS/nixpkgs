{
  channel,
  pname,
  version,
  src,
  passthru,
  meta,
  lib,
  stdenv,
  fetchurl,
  wrapGAppsHook3,
  makeDesktopItem,
  atk,
  cairo,
  dbus-glib,
  firefox-esr,
  gdk-pixbuf,
  glib,
  gtk3,
  libgcc,
  libGL,
  libva,
  xorg,
  libgbm,
  nspr,
  nss,
  pango,
  pciutils,
  alsaSupport ? true,
  alsa-lib,
  jackSupport ? true,
  libjack2,
  pulseSupport ? true,
  libpulseaudio,
  sndioSupport ? true,
  sndio,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    pname
    version
    src
    passthru
    meta
    ;

  dontPatchELF = true;
  nativeBuildInputs = [ wrapGAppsHook3 ];

  libPath =
    lib.makeLibraryPath (
      [
        atk
        cairo
        dbus-glib
        gdk-pixbuf
        glib
        gtk3
        libGL
        libva
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
      ++ lib.optional alsaSupport alsa-lib
      ++ lib.optional jackSupport libjack2
      ++ lib.optional pulseSupport libpulseaudio
      ++ lib.optional sndioSupport sndio
    )
    + ":"
    + lib.makeSearchPathOutput "lib" "lib" [ stdenv.cc.cc ];

  desktopItem = makeDesktopItem {
    name = "zotero";
    exec = "zotero -url %U";
    icon = "zotero";
    comment = finalAttrs.meta.description;
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
    mkdir -p "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
    cp -r * "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"

    ${lib.optionalString (channel == "beta") ''
      rm "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"/*.so
      ln -sf ${nspr}/lib/libnspr4.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nspr}/lib/libplc4.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nspr}/lib/libplds4.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libmozsandbox.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libgkcodecs.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/liblgpllibs.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nss}/lib/libnss3.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nss}/lib/libnssutil3.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nss}/lib/libsmime3.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libmozsqlite3.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${nss}/lib/libssl3.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libmozgtk.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libmozwayland.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
      ln -sf ${firefox-esr}/lib/firefox/libxul.so "$prefix/usr/lib/zotero-bin-${finalAttrs.version}"
    ''}

    mkdir -p "$out/bin"
    ln -s "$prefix/usr/lib/zotero-bin-${finalAttrs.version}/zotero" "$out/bin/"

    # Install desktop file and icons
    mkdir -p $out/share/applications
    cp ${finalAttrs.desktopItem}/share/applications/* $out/share/applications/
    for size in 32 64 128; do
      install -Dm444 icons/icon''${size}.png \
        $out/share/icons/hicolor/''${size}x''${size}/apps/zotero.png
    done
    install -Dm444 icons/symbolic.svg \
      $out/share/icons/hicolor/symbolic/apps/zotero-symbolic.svg

    runHook postInstall
  '';

  dontWrapGApps = true;
  preFixup = ''
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  postFixup = ''
    for executable in \
      zotero-bin plugin-container updater vaapitest \
      minidump-analyzer glxtest
    do
      if [ -e "$out/usr/lib/zotero-bin-${finalAttrs.version}/$executable" ]; then
        patchelf --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
          "$out/usr/lib/zotero-bin-${finalAttrs.version}/$executable"
      fi
    done
    find . -executable -type f -exec \
      patchelf --set-rpath "$libPath" \
        "$out/usr/lib/zotero-bin-${finalAttrs.version}/{}" \;

    wrapProgram $out/bin/zotero \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libGL ]}
  '';
})
