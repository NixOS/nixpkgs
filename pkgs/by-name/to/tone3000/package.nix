{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  writeText,
  cmake,
  ninja,
  pkg-config,
  autoPatchelfHook,
  nodejs,
  npmHooks,
  fetchNpmDeps,
  writableTmpDirAsHomeHook,
  nix-update-script,
  libx11,
  libxrandr,
  libxinerama,
  libxext,
  libxcursor,
  libxrender,
  libxscrnsaver,
  freetype,
  fontconfig,
  alsa-lib,
  curl,
  libglvnd,
  webkitgtk_4_1,
  gtk3,
  wrapGAppsHook3,
  glib-networking,
  gst_all_1,
  buildVST3 ? true,
  buildLV2 ? true,
  buildCLAP ? true,
  tone3000PublishableKey ? "",
}:

let
  version = "0.0.4";

  src = fetchFromGitHub {
    owner = "tone-3000";
    repo = "tone3000-plugin";
    tag = "v${version}";
    hash = "sha256-U+q2m9Je9P+nP/Lzg4qjHNQMZpiAQmnPbvrrg3+HJXA=";
    fetchSubmodules = true;
  };

  clap-juce-extensions = fetchFromGitHub {
    owner = "free-audio";
    repo = "clap-juce-extensions";
    rev = "c1a5ad025f95d01e03267857fa8276ebeed16500"; # GIT_TAG from plugin/CMakeLists.txt
    hash = "sha256-P8rLNI9fXGU8yxXXdOkRD/+T3AMd3zdRM8mHp62dEmA=";
    fetchSubmodules = true; # clap-libs/clap and clap-libs/clap-helpers
  };

  juce-9 = fetchFromGitHub {
    owner = "juce-framework";
    repo = "juce";
    rev = "9.0.1"; # GIT_TAG from the root CMakeLists.txt
    hash = "sha256-9YbhXKBVER7Ww9pwwd1gwm9R8/975pCNibsCqGviYTk=";
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
    hash = "sha256-lscFVYygBYzgWSDAyU1fhBmSYu8L3SV7kmacBb8Np5k=";
  };

  # The DSP test suite (root CMakeLists.txt) pulls GoogleTest in via CPM.
  googletest = fetchFromGitHub {
    owner = "google";
    repo = "googletest";
    rev = "v1.15.2"; # GIT_TAG from the root CMakeLists.txt
    hash = "sha256-1OJ2SeSscRBNr7zZ/a8bJGIqAnhkg45re0j3DtPfcXM=";
  };

  # Root CMakeLists.txt runs `include(cmake/cpm.cmake)` then CPMAddPackage()s
  # JUCE/googletest (root) and clap-juce-extensions (plugin/). All three are
  # prefetched and dropped into libs/, so we (a) disable CPM's network/git
  # fetches and (b) point each dependency at its in-tree copy. Injected right
  # after the CPM include (before any CPMAddPackage), using LIB_DIR which is
  # already set to `\${CMAKE_CURRENT_SOURCE_DIR}/libs`. (Plain double-quoted
  # Nix strings so `\${` stays a literal `\${` for CMake.)
  cpmInjection = writeText "cpm-offline.in" (
    "set(FETCHCONTENT_FULLY_DISCONNECTED ON CACHE BOOL \"\")\n"
    + "set(FETCHCONTENT_UPDATES_DISCONNECTED ON CACHE BOOL \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_JUCE \"\${LIB_DIR}/juce\" CACHE PATH \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_GOOGLETEST \"\${LIB_DIR}/googletest\" CACHE PATH \"\")\n"
    + "set(FETCHCONTENT_SOURCE_DIR_CLAP_JUCE_EXTENSIONS \"\${LIB_DIR}/clap-juce-extensions\" CACHE PATH \"\")\n"
  );

  # Self-contained source for `fetchNpmDeps`: just the UI's package.json and
  # package-lock.json at the root, so the npm-deps fetcher doesn't need to
  # unpack the whole tree.
  uiLockSrc = stdenvNoCC.mkDerivation {
    pname = "tone3000-ui-lock";
    inherit version src;
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp "${src}/ui/package.json" "${src}/ui/package-lock.json" $out/
      runHook postInstall
    '';
  };

  factoryPresets = (
    builtins.map (p: "../resources/factory-presets/${p}") [
      "029e6f8159a1468e974663d9201a1a1e.t3kpreset"
      "0f487d253737472f84e1b5c24292f577.t3kpreset"
      "17ff5d4c4c9345dfa527e533d3d98fbd.t3kpreset"
      "230b0f41771a499eb99020eccac304bc.t3kpreset"
      "2cd31d455fee4f93988a7baaf6807dbd.t3kpreset"
      "7007eb161b3c4c97a624396f2e3a3ada.t3kpreset"
      "83819e60b0604954aa46f1901de405e9.t3kpreset"
    ]
  );
in
stdenv.mkDerivation (finalAttrs: {
  pname = "tone3000";
  inherit version;

  src = src;

  __structuredAttrs = true;
  strictDeps = true;

  # The project's git submodules and its CPM-fetched dependencies (JUCE and
  # clap-juce-extensions) live at fixed paths inside the tree. JUCE and
  # clap-juce-extensions are also *patched in-place* at configure time
  # (writing back to the source tree, e.g. the WebKitGTK WebBrowserComponent
  # and ALSA handling), so these copies must live in a writable location
  # rather than the read-only nix store. Dropping them into their expected
  # `libs/` / `plugin/` paths satisfies both the in-place patching and the
  # UI's npm `file:` dependency on `@juce-framework/webview`
  # (../libs/juce/...).
  postUnpack = ''
    mkdir -p "$sourceRoot/libs/cpm" "$sourceRoot/libs" "$sourceRoot/plugin"
    cp -v ${cpm} "$sourceRoot/libs/cpm/CPM_0.40.2.cmake"
    cp -R --no-preserve=mode,ownership ${juce-9} "$sourceRoot/libs/juce"
    cp -R --no-preserve=mode,ownership ${clap-juce-extensions} "$sourceRoot/libs/clap-juce-extensions"
    cp -R --no-preserve=mode,ownership ${googletest} "$sourceRoot/libs/googletest"
  '';

  # The build sandbox is offline, so point CPM/FetchContent at the prefetched
  # in-tree copies and disable any network/git fetching at configure time.
  # (Injected as a separate .in file so the `\${LIB_DIR}` stays literal.)
  postPatch = ''
        sed -i "/^include(cmake\\/cpm.cmake)$/r ${cpmInjection}" CMakeLists.txt

        # Inject environment workarounds for WebKitGTK, Wayland and Sandboxing on plugin load
        substituteInPlace plugin/src/Editor.cpp \
          --replace-fail '#include "Editor.h"' '#include <stdlib.h>
    #include <stdio.h>
    #if defined(__linux__) || defined(__freebsd__)
    __attribute__((constructor)) static void initializeTone3000Plugin() {
      ::setenv("WEBKIT_FORCE_SANDBOX", "0", 1);
      ::setenv("WEBKIT_DISABLE_SANDBOX_THIS_IS_DANGEROUS", "1", 1);
      ::setenv("GDK_BACKEND", "x11", 1);
      ::setenv("WEBKIT_DISABLE_DMABUF_RENDERER", "1", 1);
      ::setenv("WEBKIT_DISABLE_COMPOSITING_MODE", "1", 1);

      // The temporary subprocess extracted by JUCE lacks Nix RPATHs.
      // We inject LD_LIBRARY_PATH so it can find WebKitGTK and GTK3.
      const char* oldLd = ::getenv("LD_LIBRARY_PATH");
      const char* nixLibs = "@NIX_RUNTIME_LIBS@";
      if (oldLd) {
        char newLd[4096];
        ::snprintf(newLd, sizeof(newLd), "%s:%s", nixLibs, oldLd);
        ::setenv("LD_LIBRARY_PATH", newLd, 1);
      } else {
        ::setenv("LD_LIBRARY_PATH", nixLibs, 1);
      }

      // Network and TLS dependencies for WebKitGTK under Nix
      ::setenv("GIO_EXTRA_MODULES", "@GLIB_NETWORKING@/lib/gio/modules", 1);
    }
    #endif
    #include "Editor.h"'

        # Convert JUCE WebBrowserComponent from CRLF to LF so replacements match cleanly
        sed -i 's/\r//' libs/juce/modules/juce_gui_extra/native/juce_WebBrowserComponent_linux.cpp

        # Bypass JUCE's host-side WebKit probe (which fails due to GLib conflicts inside DAWs like Ardour)
        substituteInPlace libs/juce/modules/juce_gui_extra/native/juce_WebBrowserComponent_linux.cpp \
          --replace-fail 'webKitIsAvailable = WebKitSymbols::getInstance()->isWebKitAvailable();' \
                         'webKitIsAvailable = true; // Bypasses host probe symbol mismatch inside DAWs like Ardour'

        sed -i "s|@NIX_RUNTIME_LIBS@|${lib.makeLibraryPath finalAttrs.runtimeDependencies}|g" plugin/src/Editor.cpp
        sed -i "s|@GLIB_NETWORKING@|${glib-networking.out}|g" plugin/src/Editor.cpp
  '';

  npmDeps = fetchNpmDeps {
    src = uiLockSrc;
    name = "tone3000-${version}-npm-deps";
    hash = "sha256-qqmF4etA+GqlgHhycztvFvu2MUZcjtPMwRvnDIrHpTw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    autoPatchelfHook
    wrapGAppsHook3
    nodejs
    npmHooks.npmConfigHook
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    libx11
    libxrandr
    libxinerama
    libxext
    libxcursor
    freetype
    fontconfig
    alsa-lib
    curl
    libglvnd
    webkitgtk_4_1
    gtk3
    glib-networking
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
  ];

  # JUCE dlopens X11/GL libs at runtime, and the WebKitGTK UI is loaded
  # dynamically too. autoPatchelfHook bakes these into the RPATH.
  runtimeDependencies = [
    libx11
    libxext
    libxcursor
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    libglvnd
    gtk3
    webkitgtk_4_1
  ];

  npmRoot = "ui";

  # `npmConfigHook` (a postPatch hook) runs `npm ci` offline in ui/ using
  # npmDeps. Then build the Vite UI into ../plugin/webview before configuring
  # CMake, so its binary-data glob picks the assets up in a single configure.
  preConfigure = ''
    set -x

    publishableKey="${tone3000PublishableKey}"
    if [ -z "$publishableKey" ]; then
      echo "Extracting publishable key from pre-built release binary..."
      tar -xf ${releaseBinary} --strip-components=1 TONE3000-v${version}-linux-x64/TONE3000
      publishableKey=$(strings TONE3000 | grep -o -E "t3k_pub_[a-zA-Z0-9_-]+" | head -n1)
      rm TONE3000
      echo "Extracted key: $publishableKey"
    fi

    pushd ui
      export VITE_T3K_PUBLISHABLE_KEY="$publishableKey"
      npm run build
    popd
    set +x
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)

    (lib.cmakeBool "BUILD_AAX" false)
    (lib.cmakeBool "BUILD_LV2" buildLV2)
    (lib.cmakeBool "BUILD_CLAP" buildCLAP)

    "-DCMAKE_CXX_FLAGS=-DJUCE_USE_EXTERNAL_TEMPORARY_SUBPROCESS=1"
  ];

  cmakeBuildType = "Release";

  dontNpmInstall = true;
  dontNpmBuild = true;

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

    # Icon + desktop entry
    install -Dm644 ../script/installer/linux/tone3000.png \
      "$out/share/icons/hicolor/512x512/apps/tone3000.png"
    install -Dm644 /dev/stdin "$out/share/applications/tone3000.desktop" <<EOF
    [Desktop Entry]
    Type=Application
    Name=TONE3000
    Comment=Play NAM captures and IRs straight from TONE3000
    Exec=TONE3000
    Icon=tone3000
    Terminal=false
    Categories=AudioVideo;Audio;Music;
    StartupWMClass=TONE3000
    EOF

    # Factory presets, system-wide
    install -dm755 "$out/share/tone3000/factory-presets"
    install -m644 ${lib.concatStringsSep " " factoryPresets} \
      "$out/share/tone3000/factory-presets/"

    runHook postInstall
  '';

  # autoPatchelfHook skips adding runtimeDependencies to the RUNPATH of shared
  # libraries. appendRunpaths forcefully appends these paths to all ELF files,
  # ensuring the plugins can successfully dlopen WebKitGTK, GTK3, and GLib.
  appendRunpaths = [ (lib.makeLibraryPath finalAttrs.runtimeDependencies) ];

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
