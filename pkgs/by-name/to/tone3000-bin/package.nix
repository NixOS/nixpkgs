{
  alsa-lib,
  autoPatchelfHook,
  cpio,
  copyDesktopItems,
  curl,
  fetchurl,
  fontconfig,
  freetype,
  gtk3,
  lib,
  libGL,
  libx11,
  libxcomposite,
  libxcursor,
  libxext,
  libxinerama,
  libxrandr,
  libxrender,
  libjack2,
  libsysprof-capture,
  libxkbcommon,
  makeDesktopItem,
  patchelf,
  pcre2,
  stdenv,
  util-linux,
  webkitgtk_4_1,
  xar,
}:
let
  isLinux = stdenv.hostPlatform.isLinux;
  isDarwin = stdenv.hostPlatform.isDarwin;
  linuxArch = if stdenv.hostPlatform.isAarch64 then "aarch64" else "x64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000-bin";
  version = "0.0.12";

  strictDeps = true;
  __structuredAttrs = true;

  # This package installs upstream release binaries. The -bin suffix distinguishes
  # it from source-build packaging, which integrates upstream's patched JUCE and
  # pinned NeuralAmpModelerCore, AudioDSPTools, and clap-juce-extensions sources.
  # Source-build work is tracked separately in https://github.com/NixOS/nixpkgs/pull/559444.
  src =
    if isLinux then
      fetchurl {
        url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-linux-${linuxArch}.tar.gz";
        hash =
          {
            x64 = "sha256-xF6l1k5u75kbFPGIOkJJ7RqIMlPbGp2fBgXgVAq6X8c=";
            aarch64 = "sha256-BpKfpy23VbUAYTbMTouv25lb+9pE1tAVUvxIU7lGlek=";
          }
          .${linuxArch};
      }
    else
      fetchurl {
        url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-macos-universal.pkg";
        hash = "sha256-wfCUYVIgdjheQGDKqb9YOvtqbKlhVay1tSco2KImb6c=";
      };

  dontBuild = true;

  buildInputs = lib.optionals isLinux [
    alsa-lib
    curl
    fontconfig
    freetype
    gtk3
    libGL
    libx11
    libxcomposite
    libxcursor
    libxext
    libxinerama
    libxrandr
    libxrender
    libjack2
    libsysprof-capture
    libxkbcommon
    pcre2
    util-linux
    webkitgtk_4_1
  ];

  nativeBuildInputs =
    lib.optionals isLinux [
      autoPatchelfHook
      copyDesktopItems
      patchelf
    ]
    ++ lib.optionals isDarwin [
      cpio
      xar
    ];

  unpackPhase =
    if isLinux then
      ''
        mkdir source
        tar --extract --gzip --file "$src" --strip-components=1 --directory source
      ''
    else
      ''
        mkdir pkg source
        xar --extract --file "$src" --directory pkg
        for component in _clap.pkg _vst3.pkg _standalone.pkg; do
          gzip --decompress --stdout "pkg/$component/Payload" \
            | (cd source && cpio --extract --make-directories --quiet)
        done
      '';

  sourceRoot = "source";

  desktopItems = lib.optionals isLinux [
    (makeDesktopItem {
      name = "tone3000";
      desktopName = "TONE3000";
      exec = "tone3000";
      icon = "tone3000";
      comment = "Play NAM captures and impulse responses from TONE3000";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      startupWMClass = "TONE3000";
    })
  ];

  installPhase =
    if isLinux then
      ''
        runHook preInstall

        install -Dm755 TONE3000 "$out/bin/tone3000"
        install -Dm644 tone3000.png "$out/share/icons/hicolor/512x512/apps/tone3000.png"
        install -Dm755 TONE3000.clap "$out/lib/clap/TONE3000.clap"
        install -d "$out/lib/lv2" "$out/lib/vst3"
        cp -R TONE3000.lv2 "$out/lib/lv2/"
        cp -R TONE3000.vst3 "$out/lib/vst3/"
        install -d "$out/share/tone3000"
        cp -R factory-presets "$out/share/tone3000/"

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        install -d \
          "$out/Applications" \
          "$out/bin" \
          "$out/Library/Audio/Plug-Ins/CLAP" \
          "$out/Library/Audio/Plug-Ins/VST3"
        cp -R TONE3000.clap "$out/Library/Audio/Plug-Ins/CLAP/"
        cp -R TONE3000.vst3 "$out/Library/Audio/Plug-Ins/VST3/"
        cp -R Applications/TONE3000.app "$out/Applications/"
        ln -s ../Applications/TONE3000.app/Contents/MacOS/TONE3000 "$out/bin/tone3000"

        runHook postInstall
      '';

  preFixup = lib.optionalString isLinux ''
    runtimeLibraryPath=${
      lib.makeLibraryPath [
        alsa-lib
        curl
        fontconfig
        freetype
        gtk3
        libGL
        libx11
        libxcomposite
        libxcursor
        libxext
        libxinerama
        libxrandr
        libxrender
        libjack2
        libsysprof-capture
        libxkbcommon
        pcre2
        util-linux
        webkitgtk_4_1
      ]
    }

    tone3000AddRuntimeLibraryPath() {
      for plugin in \
        "$out/bin/tone3000" \
        "$out/lib/clap/TONE3000.clap" \
        "$out/lib/lv2/TONE3000.lv2/libTONE3000.so" \
        "$out/lib/vst3/TONE3000.vst3/Contents/${stdenv.hostPlatform.system}/TONE3000.so"; do
        patchelf --add-rpath "$runtimeLibraryPath" "$plugin"
      done
    }
    postFixupHooks+=(tone3000AddRuntimeLibraryPath)
  '';

  doInstallCheck = true;
  installCheckPhase =
    if isLinux then
      ''
        test -x "$out/bin/tone3000"
        test -s "$out/share/applications/tone3000.desktop"
        test -s "$out/share/icons/hicolor/512x512/apps/tone3000.png"
        test -s "$out/lib/clap/TONE3000.clap"
        test -s "$out/lib/lv2/TONE3000.lv2/libTONE3000.so"
        test -s "$out/lib/vst3/TONE3000.vst3/Contents/${stdenv.hostPlatform.system}/TONE3000.so"
        test -s "$out/lib/vst3/TONE3000.vst3/Contents/Resources/moduleinfo.json"
      ''
    else
      ''
        test -x "$out/bin/tone3000"
        test -s "$out/Applications/TONE3000.app/Contents/Info.plist"
        test -s "$out/Library/Audio/Plug-Ins/CLAP/TONE3000.clap/Contents/MacOS/TONE3000"
        test -s "$out/Library/Audio/Plug-Ins/VST3/TONE3000.vst3/Contents/MacOS/TONE3000"
        test -s "$out/Library/Audio/Plug-Ins/VST3/TONE3000.vst3/Contents/Resources/moduleinfo.json"
      '';

  meta = {
    mainProgram = "tone3000";
    description = "NAM and impulse-response loader integrated with TONE3000 (upstream binaries)";
    homepage = "https://github.com/tone-3000/tone3000-plugin";
    changelog = "https://github.com/tone-3000/tone3000-plugin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ _9prestidigitator ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})
