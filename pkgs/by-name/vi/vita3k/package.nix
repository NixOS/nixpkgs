{
  lib,
  alsa-lib,
  boost,
  clangStdenv,
  cmake,
  common-updater-scripts,
  curl,
  darwin,
  fetchFromGitHub,
  ffmpeg_7,
  jq,
  libicns,
  libpulseaudio,
  librsvg,
  makeWrapper,
  moltenvk,
  ninja,
  openssl,
  pkg-config,
  python3,
  qt6,
  sdl3,
  vulkan-loader,
  writeShellScript,
}:

clangStdenv.mkDerivation (finalAttrs: {
  pname = "vita3k";
  version = "4437";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Vita3K";
    repo = "Vita3K";
    rev = "b123d9ddc974a5e81fdfba92f0eed9c4428d11d4";
    fetchSubmodules = true;
    hash = "sha256-PK5WP6O+NnXRjPGt5vTwhFzqI8mRyIH5mg+ojxyWolo=";
  };

  patches = [
    # Not upstreamable: the AAC decoder uses libavcodec internals, which upstream only
    # supports with its static FFmpeg. The store path pins the libavcodec it was built
    # against, and the patch checks the libavcodec version at configure time
    # https://github.com/Vita3K/Vita3K/pull/4457
    ./use-system-ffmpeg.patch
    # sips, iconutil and codesign aren't in the darwin sandbox, upstream relies on them
    # being present on macOS
    # https://github.com/Vita3K/Vita3K/pull/4457
    ./optional-macos-tools.patch
  ];

  postPatch = ''
    # the build number comes from git; a branch other than master keeps the self-updater off
    substituteInPlace cmake/version.cmake \
      --replace-fail 'if(GIT_HASH STREQUAL "")' '
        set(GIT_COUNT "${finalAttrs.version}")
        set(GIT_HASH "${builtins.substring 0 8 finalAttrs.src.rev}")
        set(GIT_REPO "Vita3K")
        set(GIT_BRANCH "nixpkgs")
        if(GIT_HASH STREQUAL "")'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    qt6.qttools
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    # mig, for dynarmic's macOS exception handler
    darwin.bootstrap_cmds
    libicns
    librsvg
    makeWrapper
  ];

  buildInputs = [
    boost
    curl
    ffmpeg_7
    openssl
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    sdl3
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isLinux [
    alsa-lib
    libpulseaudio
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [ moltenvk ];

  cmakeFlags = [
    # clang-scan-deps runs outside the cc wrapper and can't find the headers
    (lib.cmakeBool "CMAKE_CXX_SCAN_FOR_MODULES" false)
    (lib.cmakeBool "FMT_MODULE" false)
    (lib.cmakeBool "USE_DISCORD_RICH_PRESENCE" false)
    (lib.cmakeBool "VITA3K_FORCE_SYSTEM_BOOST" true)
    (lib.cmakeBool "VITA3K_USE_SYSTEM_FFMPEG" true)
    (lib.cmakeBool "VITA3K_USE_SYSTEM_SDL" true)
  ]
  ++ lib.optionals clangStdenv.hostPlatform.isDarwin [
    (lib.cmakeBool "VITA3K_USE_SYSTEM_MOLTENVK" true)
    # macdeployqt would copy Qt into the bundle, and the linker already signs it
    (lib.cmakeBool "CODESIGN_EXECUTABLE" false)
    (lib.cmakeBool "MACDEPLOYQT_EXECUTABLE" false)
    # the icon is built in postInstall
    (lib.cmakeBool "ICONUTIL_EXECUTABLE" false)
    (lib.cmakeBool "SIPS_EXECUTABLE" false)
    (lib.cmakeFeature "MACOSX_BUNDLE_ICON_FILE" "Vita3K")
  ];

  postInstall = ''
    # headers, static libraries and CMake files of the bundled dependencies
    rm -r $out/include $out/lib $out/share/cmake
  ''
  # upstream's CMake only installs on Linux; on macOS the bundle stays in the build directory
  + lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r bin/Vita3K.app $out/Applications
    # so wrapQtAppsHook doesn't take the library for a program
    chmod -x $out/Applications/Vita3K.app/Contents/Frameworks/libMoltenVK.dylib
    for size in 16 32 128 256 512 1024; do
      rsvg-convert -w $size -h $size ../vita3k/org.vita3k.vita3k.svg -o icon_$size.png
    done
    png2icns $out/Applications/Vita3K.app/Contents/Resources/Vita3K.icns icon_*.png
    makeWrapper $out/Applications/Vita3K.app/Contents/MacOS/Vita3K $out/bin/Vita3K
  ''
  # the command of the AppImage-based package; macOS file systems ignore case
  + lib.optionalString clangStdenv.hostPlatform.isLinux ''
    ln -s Vita3K $out/bin/vita3k
  '';

  # libvulkan.so.1 is loaded with dlopen
  qtWrapperArgs = lib.optionals clangStdenv.hostPlatform.isLinux [
    "--prefix"
    "LD_LIBRARY_PATH"
    ":"
    (lib.makeLibraryPath [ vulkan-loader ])
  ];

  # versions are build numbers; the release notes of each build name its commit
  passthru.updateScript = writeShellScript "update-vita3k" ''
    set -euo pipefail
    PATH=${
      lib.makeBinPath [
        common-updater-scripts
        curl
        jq
      ]
    }:$PATH
    release=$(curl -sSfL ''${GITHUB_TOKEN:+-H "Authorization: Bearer $GITHUB_TOKEN"} \
      https://api.github.com/repos/Vita3K/Vita3K-builds/releases/latest)
    version=$(jq -r .tag_name <<< "$release")
    rev=$(jq -r .body <<< "$release" | grep -oE 'Vita3K/Vita3K/commit/[0-9a-f]{40}' | head -1 | cut -d/ -f4)
    update-source-version vita3k "$version" --rev="$rev"
  '';

  meta = {
    description = "Experimental PlayStation Vita emulator";
    homepage = "https://vita3k.org/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      ekisu
      iedame
    ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
    mainProgram = "Vita3K";
  };
})
