{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  writeText,
  cmake,
  ninja,
  pkg-config,
  autoPatchelfHook,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxi,
  freetype,
  fontconfig,
  alsa-lib,
  jack2,
  curl,
  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
  tone3000PublishableKey ? "",
}:

let
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "tone-3000";
    repo = "tone3000-plugin";
    tag = "v${version}";
    hash = "sha256-eqytMDN727rAUFCWkr1eSYpPwTdjtgPKpl1iusL/oWs=";
    fetchSubmodules = true;
  };

  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "c1a5ad025f95d01e03267857fa8276ebeed16500"; # GIT_TAG from plugin/CMakeLists.txt
    hash = "sha256-P8rLNI9fXGU8yxXXdOkRD/+T3AMd3zdRM8mHp62dEmA=";
    fetchSubmodules = true; # clap-libs/clap and clap-libs/clap-helpers
  };

  juce = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = "9.0.3"; # GIT_TAG from the root CMakeLists.txt
    hash = "sha256-eB5HvUiKXRAp53EApiX0jGNhXVtt83zD9TaNOhdQIjc=";
  };

  # FreeType 2.13.3 (VER-2-13-3 GIT_TAG from the root CMakeLists.txt), built
  # statically into the Linux GUI targets instead of resolving from the host.
  freetype-static = fetchFromGitHub {
    owner = "freetype";
    repo = "freetype";
    tag = "VER-2-13-3";
    hash = "sha256-4l90lDtpgm5xlh2m7ifrqNy373DTRTULRkAzicrM93c=";
  };

  # CPM.cmake, vendored into the tree (the build sandbox is offline, so the
  # bootstrap `cmake/cpm.cmake` must find it already present under libs/cpm/).
  cpm = fetchurl {
    url = "https://raw.githubusercontent.com/cpm-cmake/CPM.cmake/v0.40.2/cmake/CPM.cmake";
    sha256 = "173q8f9xilayndv26c75bgg1v4b66jh27333qq4czp89a8rr85nh";
  };

  # Pre-compiled official Linux release binary used to extract the production publishable API key
  releaseBinary = fetchurl {
    url = "https://github.com/tone-3000/tone3000-plugin/releases/download/v${version}/TONE3000-v${version}-linux-x64.tar.gz";
    hash = "sha256-xF6l1k5u75kbFPGIOkJJ7RqIMlPbGp2fBgXgVAq6X8c=";
  };

  # The DSP test suite (root CMakeLists.txt) pulls GoogleTest in via CPM.
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v1.15.2"; # GIT_TAG from the root CMakeLists.txt
    hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
  };

  # Root CMakeLists.txt runs `include(cmake/cpm.cmake)` then CPMAddPackage()s
  # freetype, JUCE and googletest (root) and clap-juce-extensions (plugin/).
  # All four are prefetched and dropped into libs/, so we (a) disable CPM's
  # network/git fetches and (b) point each dependency at its in-tree copy.
  # Injected right after the CPM include (before any CPMAddPackage), using
  # LIB_DIR which is already set to `\${CMAKE_CURRENT_SOURCE_DIR}/libs`.
  # (Plain double-quoted Nix strings so `\${` stays a literal `\${` for CMake.)
  #
  # FETCHCONTENT_SOURCE_DIR_<UPPERCASED NAME> keeps FetchContent's name as-is,
  # so clap-juce-extensions' variable really does contain dashes.
  cpmInjection = writeText "cpm-offline.in" (
    "set(FETCHCONTENT_FULLY_DISCONNECTED ON CACHE BOOL \"\")\n"
    + "set(FETCHCONTENT_UPDATES_DISCONNECTED ON CACHE BOOL \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_FREETYPE \"\${LIB_DIR}/freetype\" CACHE PATH \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_JUCE \"\${LIB_DIR}/juce\" CACHE PATH \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_GOOGLETEST \"\${LIB_DIR}/googletest\" CACHE PATH \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_CLAP-JUCE-EXTENSIONS \"\${LIB_DIR}/clap-juce-extensions\" CACHE PATH \"\")\n"
  );

  # Where plugin/src/PresetManager.cpp looks for the all-users factory presets
  # on Linux. It is hardcoded there (the tarball installer only ships a
  # per-user copy), so postPatch redirects it here.
  factoryPresetsDir = "/share/TONE3000/Presets/Factory";

in
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000";
  inherit version;

  src = src;

  __structuredAttrs = true;
  strictDeps = true;

  # The project's git submodules and its CPM-fetched dependencies (JUCE,
  # FreeType and clap-juce-extensions) live at fixed paths inside the tree.
  # JUCE is also *patched in-place* at configure time (see the T3K_* patches in
  # the root CMakeLists.txt), so this copy must live in a writable location
  # rather than the read-only nix store.
  postUnpack = ''
    mkdir -p "$sourceRoot/libs/cpm"
    cp -v ${cpm} "$sourceRoot/libs/cpm/CPM_0.40.2.cmake"
    cp -R --no-preserve=mode,ownership ${juce} "$sourceRoot/libs/juce"
    cp -R --no-preserve=mode,ownership ${freetype-static} "$sourceRoot/libs/freetype"
    cp -R --no-preserve=mode,ownership ${clap-juce-extensions} "$sourceRoot/libs/clap-juce-extensions"
    cp -R --no-preserve=mode,ownership ${googletest} "$sourceRoot/libs/googletest"
  '';

  # The build sandbox is offline, so point CPM/FetchContent at the prefetched
  # in-tree copies and disable any network/git fetching at configure time.
  # (Injected as a separate .in file so the `\${LIB_DIR}` stays literal.)
  postPatch = ''
    sed -i "/^include(cmake\\/cpm.cmake)/r ${cpmInjection}" CMakeLists.txt
    grep -q "FETCHCONTENT_FULLY_DISCONNECTED" CMakeLists.txt

    # The distro/system-wide factory preset directory is hardcoded to
    # /usr/share/TONE3000/Presets/Factory; that path does not exist here, so
    # point it at our own store output.
    substituteInPlace plugin/src/PresetManager.cpp \
      --replace-fail \
        'return juce::File("/usr/share/TONE3000/Presets/Factory");' \
        'return juce::File("${placeholder "out"}'${factoryPresetsDir}'");'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    autoPatchelfHook
    copyDesktopItems
  ];

  # juce_gui_basics includes the X11 headers (Xrandr, Xinerama, Xcursor,
  # XInput2) but resolves the matching libraries through dlopen at runtime, so
  # the lib* entries only provide headers here; see runtimeDependencies.
  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxcursor
    libxi
    freetype # pkg-config only: fontconfig.pc's Requires, filtered out of the link
    fontconfig
    alsa-lib
    jack2 # JUCE_JACK=1 (plugin/CMakeLists.txt) needs the headers; libjack.so.0
    curl # JUCE_USE_CURL=1 is the only backend on Linux with TLS; dlopened
  ];

  # Libraries JUCE dlopens instead of linking: the X11 family (X11Symbols),
  # libjack.so.0 for the JACK driver and libcurl.so.4 for the HTTPS backend
  # JUCE_USE_CURL=1 needs on Linux. autoPatchelfHook cannot see any of them,
  # hence appendRunpaths below.
  runtimeDependencies = [
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    libxi
    jack2
    curl
  ];

  # The publishable key is baked into plugin/ui/core/T3kConfig.h at configure
  # time, read from the environment by plugin/ui/NativeUi.cmake. Take it from
  # the pre-built official binary unless overridden by the caller.
  # T3K_API_DOMAIN and T3K_UPDATE_NOTICE keep their upstream defaults here:
  # production origin, no startup "update available" nag (updates come through
  # Nix, not through the plugin).
  preConfigure = ''
    publishableKey="${tone3000PublishableKey}"
    if [ -z "$publishableKey" ]; then
      echo "Extracting publishable key from pre-built release binary..."
      tar -xf ${releaseBinary} --strip-components=1 TONE3000-v${version}-linux-x64/TONE3000
      publishableKey=$(strings TONE3000 | grep -o -E "t3k_pub_[a-zA-Z0-9_-]+" | head -n1)
      rm TONE3000
      echo "Extracted key: $publishableKey"
    fi
    export T3K_PUBLISHABLE_KEY="$publishableKey"
  '';

  cmakeFlags = [
    (lib.cmakeBool "BUILD_AAX" false)
    (lib.cmakeBool "BUILD_LV2" buildLV2)
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)
  ];

  cmakeBuildType = "Release";

  # DspTests (the DSP test suite) and PresetTool are not shipped; building only
  # the plugin targets keeps them and their assets out of the build.
  buildPhase = ''
    runHook preBuild

    cmake --build . --parallel $NIX_BUILD_CORES --target TONE3000_Standalone \
      ${lib.optionalString buildVST3 "TONE3000_VST3"} \
      ${lib.optionalString buildLV2 "TONE3000_LV2"} \
      ${lib.optionalString buildCLAP "TONE3000_CLAP"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    pushd plugin/TONE3000_artefacts/Release
      install -Dm755 Standalone/TONE3000 "$out/bin/TONE3000"

      ${lib.optionalString buildVST3 ''
        mkdir -p "$out/lib/vst3"
        cp -r VST3/TONE3000.vst3 "$out/lib/vst3/"
      ''}

      ${lib.optionalString buildLV2 ''
        mkdir -p "$out/lib/lv2"
        cp -r LV2/TONE3000.lv2 "$out/lib/lv2/"
      ''}

      ${lib.optionalString buildCLAP ''
        mkdir -p "$out/lib/clap"
        cp -r CLAP/TONE3000.clap "$out/lib/clap/"
      ''}
    popd

    # Icon (the desktop entry comes from desktopItems below)
    install -Dm644 ../script/installer/linux/tone3000.png \
      "$out/share/icons/hicolor/512x512/apps/tone3000.png"

    # Factory presets, system-wide: the directory postPatch pointed
    # PresetManager at, overlaid by the user's own Factory folder. Globbed at
    # build time (the file names contain spaces), never listed in Nix: reading
    # the fetched source with builtins.readDir is eval-time I/O, which the
    # nixpkgs eval checks reject.
    install -Dm644 ${src}/resources/factory-presets/*.t3kpreset \
      -t "$out${factoryPresetsDir}"

    runHook postInstall
  '';

  # autoPatchelfHook skips adding runtimeDependencies to the RUNPATH of shared
  # libraries. appendRunpaths forcefully appends these paths to all ELF files,
  # so the plugins can dlopen X11/libcurl/libjack too.
  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.runtimeDependencies) ];

  desktopItems = [
    (makeDesktopItem {
      name = "tone3000";
      desktopName = "TONE3000";
      comment = "Play NAM captures and IRs straight from TONE3000";
      exec = "TONE3000";
      icon = "tone3000";
      terminal = false;
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      startupWMClass = "TONE3000";
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Load Neural Amp Modeler captures and impulse responses straight from TONE3000";
    homepage = "https://github.com/tone-3000/tone3000-plugin";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ eymeric ];
    mainProgram = "TONE3000";
  };
})
