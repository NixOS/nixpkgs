{
  alsa-lib,
  autoPatchelfHook,
  cpio,
  copyDesktopItems,
  curl,
  coreutils,
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
  nix-update-script,
  pcre2,
  stdenv,
  util-linux,
  webkitgtk_4_1,
  writeShellApplication,
  xar,
}:
let
  inherit (stdenv.hostPlatform) isDarwin isLinux;
  presetInstaller = writeShellApplication {
    name = "tone3000-install-presets";
    runtimeInputs = [ coreutils ];
    text = ''
      packageDir=$(dirname "$(dirname "$(readlink -f "$0")")")
      presetDir=${
        if isDarwin then
          ''"$HOME/Library/Application Support/TONE3000/Presets/Factory"''
        else
          ''"''${XDG_CONFIG_HOME:-$HOME/.config}/TONE3000/Presets/Factory"''
      }
      mkdir -p "$presetDir"
      cp --update=none "$packageDir/share/tone3000/factory-presets/"*.t3kpreset "$presetDir/"
      echo "Factory presets installed in $presetDir (existing files preserved). Restart TONE3000 to rescan."
    '';
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000";
  version = "0.0.12";

  strictDeps = true;
  __structuredAttrs = true;

  src =
    finalAttrs.passthru.sources.${stdenv.hostPlatform.system}
      or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  dontBuild = true;
  dontStrip = true;

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
    ]
    ++ lib.optionals isDarwin [
      cpio
      xar
    ];

  sourceRoot = lib.optionalString isDarwin "source";

  unpackPhase = lib.optionalString isDarwin ''
    runHook preUnpack
    mkdir pkg source
    xar -xf "$src" -C pkg
    for component in _clap.pkg _vst3.pkg _standalone.pkg _presets.pkg; do
      gzip --decompress --stdout "pkg/$component/Payload" \
        | (cd source && cpio --extract --make-directories --quiet)
    done
    runHook postUnpack
  '';

  postInstall = ''
    install -Dm755 ${presetInstaller}/bin/tone3000-install-presets "$out/bin/tone3000-install-presets"
  '';

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
        install -d "$out/share/tone3000"
        cp -R "Library/Application Support/TONE3000/Presets/Factory" "$out/share/tone3000/factory-presets"

        runHook postInstall
      '';

  # JUCE loads libraries dynamically in both the executable and plugin shared
  # libraries. runtimeDependencies alone only covers executables with PT_INTERP.
  appendRunpaths = lib.optionals isLinux [ (lib.makeLibraryPath finalAttrs.buildInputs) ];

  passthru = {
    sources = {
      x86_64-linux = fetchurl {
        url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-linux-x64.tar.gz";
        hash = "sha256-xF6l1k5u75kbFPGIOkJJ7RqIMlPbGp2fBgXgVAq6X8c=";
      };
      aarch64-linux = fetchurl {
        url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-linux-aarch64.tar.gz";
        hash = "sha256-BpKfpy23VbUAYTbMTouv25lb+9pE1tAVUvxIU7lGlek=";
      };
      aarch64-darwin = fetchurl {
        url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${finalAttrs.version}/TONE3000-v${finalAttrs.version}-macos-universal.pkg";
        hash = "sha256-wfCUYVIgdjheQGDKqb9YOvtqbKlhVay1tSco2KImb6c=";
      };
    };
    updateScript = nix-update-script {
      # fetchurl subpackages do not point back to this file via meta.position.
      extraArgs = [
        "--override-filename"
        "pkgs/by-name/to/tone3000/package.nix"
      ]
      ++ lib.concatMap (platform: [
        "--subpackage"
        "sources.${platform}"
      ]) finalAttrs.meta.platforms;
    };
  };

  meta = {
    mainProgram = "tone3000";
    description = "NAM and impulse-response loader integrated with TONE3000";
    longDescription = ''
      Includes the standalone application, audio plugins, and the
      tone3000-install-presets helper for installing factory presets.

      Run tone3000-install-presets once to install the bundled factory presets
      into your user preset directory, then restart the standalone application
      or reload the plugin. Existing preset files are preserved. The upstream
      binaries do not search the Nix store for factory presets.
    '';
    homepage = "https://github.com/tone-3000/tone3000-plugin";
    changelog = "https://github.com/tone-3000/tone3000-plugin/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ _9prestidigitator ];
    platforms = builtins.attrNames finalAttrs.passthru.sources;
  };
})
