{
  lib,
  alsa-lib,
  boost,
  clangStdenv,
  cmake,
  common-updater-scripts,
  curl,
  fetchFromGitHub,
  ffmpeg_7,
  jq,
  libpulseaudio,
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
  version = "4403";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "Vita3K";
    repo = "Vita3K";
    rev = "a631dd35d46747fdb27d7715a0524ea67b0b1a89";
    fetchSubmodules = true;
    hash = "sha256-QJNtfYf9Zwt6e8+v25yy9Q96nLRp4nF5lzpLq9ciA6U=";
  };

  patches = [
    # https://github.com/Vita3K/Vita3K/pull/4457
    ./use-system-sdl3.patch
    ./use-system-ffmpeg.patch
    ./install-datadir-assets.patch
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
  ];

  buildInputs = [
    alsa-lib
    boost
    curl
    ffmpeg_7
    libpulseaudio
    openssl
    qt6.qtbase
    qt6.qtmultimedia
    qt6.qtsvg
    sdl3
  ];

  cmakeFlags = [
    # clang-scan-deps runs outside the cc wrapper and can't find the headers
    (lib.cmakeBool "CMAKE_CXX_SCAN_FOR_MODULES" false)
    (lib.cmakeBool "FMT_MODULE" false)
    (lib.cmakeBool "USE_DISCORD_RICH_PRESENCE" false)
    (lib.cmakeBool "VITA3K_FORCE_SYSTEM_BOOST" true)
    (lib.cmakeBool "VITA3K_USE_SYSTEM_FFMPEG" true)
    (lib.cmakeBool "VITA3K_USE_SYSTEM_SDL" true)
  ];

  postInstall = ''
    # headers, static libraries and CMake files of the bundled dependencies
    rm -r $out/include $out/lib $out/share/cmake
    # the command of the AppImage-based package
    ln -s Vita3K $out/bin/vita3k
  '';

  # libvulkan.so.1 is loaded with dlopen
  qtWrapperArgs = [
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
    maintainers = with lib.maintainers; [ ekisu ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "Vita3K";
  };
})
