{
  config,
  lib,
  stdenv,
  fetchFromGitHub,
  fetchFromGitLab,
  applyPatches,
  autoAddDriverRunpath,
  android-tools,
  avahi,
  boost,
  cli11,
  cmake,
  eigen,
  ffmpeg,
  freetype,
  git,
  glib,
  glm,
  glslang,
  harfbuzz,
  hexdump,
  kdePackages,
  libarchive,
  libdrm,
  libGL,
  libnotify,
  libpulseaudio,
  librsvg,
  libva,
  libx11,
  libxrandr,
  makeDesktopItem,
  nix-update-script,
  nlohmann_json,
  opencomposite,
  openxr-loader,
  pipewire,
  pkg-config,
  python3,
  qt6,
  sdl2-compat,
  shaderc,
  systemd,
  udev,
  vulkan-headers,
  vulkan-loader,
  x264,
  xrizer,
  cudaSupport ? config.cudaSupport,
  # WiVRn defaults to the first path but the others can be manually selected
  ovrCompatSearchPaths ? "${xrizer}/lib/xrizer:${opencomposite}/lib/opencomposite",
  # Only build the OpenXR client library. Useful for building the client library for a different architecture,
  # e.g. 32-bit library while running 64-bit service on host, so 32-bit apps can connect to the runtime
  clientLibOnly ? false,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "wivrn";
  version = "26.6.1";

  src = fetchFromGitHub {
    owner = "wivrn";
    repo = "wivrn";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eXU7hYLYchAb6AbCyINfTmOp0NdxK35Kg9tcid2ucg4=";
  };

  monado = applyPatches {
    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = "1b526bb3a0ff326ecd05af4c2c541407f53c6d4b";
      hash = "sha256-SzuCQ1uX15vFGwGt3gswlVF2Su8sIND4R3tsTJ4T1LY=";
    };

    postPatch = ''
      ${finalAttrs.src}/patches/apply.sh ${finalAttrs.src}/patches/monado/*
    '';
  };

  strictDeps = true;

  # Let's make sure our monado source revision matches what is used by WiVRn upstream
  postUnpack = ''
    ourMonadoRev="${finalAttrs.monado.src.rev}"
    theirMonadoRev=$(cat ${finalAttrs.src.name}/monado-rev)
    if [ ! "$theirMonadoRev" == "$ourMonadoRev" ]; then
      echo "Our Monado source revision doesn't match CMakeLists.txt." >&2
      echo "  theirs: $theirMonadoRev" >&2
      echo "    ours: $ourMonadoRev" >&2
      return 1
    fi
  '';

  nativeBuildInputs = [
    cmake
    git
    glib
    glslang
    hexdump
    librsvg
    pkg-config
    python3
  ]
  ++ lib.optionals (!clientLibOnly) [
    qt6.wrapQtAppsHook
  ]
  ++ lib.optionals cudaSupport [
    autoAddDriverRunpath
  ];

  buildInputs = [
    android-tools
    eigen
    freetype
    glm
    harfbuzz
    libGL
    libx11
    libxrandr
    openxr-loader
    shaderc
    systemd
    udev
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals (!clientLibOnly) [
    avahi
    boost
    cli11
    ffmpeg
    kdePackages.kcoreaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qcoro
    kdePackages.qqc2-desktop-style
    libarchive
    libdrm
    libnotify
    libpulseaudio
    librsvg
    libva
    nlohmann_json
    pipewire
    qt6.qtbase
    qt6.qtsvg
    qt6.qttools
    x264
  ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_BUILD_DASHBOARD" (!clientLibOnly))
    (lib.cmakeBool "WIVRN_BUILD_SERVER" (!clientLibOnly))
    (lib.cmakeBool "WIVRN_BUILD_SERVER_LIBRARY" true)
    (lib.cmakeBool "WIVRN_BUILD_WIVRNCTL" (!clientLibOnly))
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "WIVRN_OPENXR_MANIFEST_TYPE" "absolute")
    (lib.cmakeBool "WIVRN_OPENXR_MANIFEST_ABI" clientLibOnly)
    (lib.cmakeFeature "GIT_DESC" "v${finalAttrs.version}")
    (lib.cmakeFeature "GIT_COMMIT" "v${finalAttrs.version}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${finalAttrs.monado}")
  ]
  ++ lib.optionals (!clientLibOnly) [
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_VULKAN_ENCODE" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_FEATURE_STEAMVR_LIGHTHOUSE" true)
    (lib.cmakeFeature "OVR_COMPAT_SEARCH_PATH" ovrCompatSearchPaths)
  ];

  dontWrapQtApps = true;

  preFixup = lib.optional (!clientLibOnly) ''
    wrapProgram "$out/bin/wivrn-server" \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          sdl2-compat
          udev
        ]
      }
    wrapQtApp "$out/bin/wivrn-dashboard" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]} \
      --prefix PATH : ${lib.makeBinPath [ android-tools ]}
  '';

  desktopItems = lib.optionals (!clientLibOnly) [
    (makeDesktopItem {
      name = "WiVRn Server";
      desktopName = "WiVRn Server";
      genericName = "WiVRn Server";
      comment = "Play your PC VR games on a standalone headset";
      icon = "io.github.wivrn.wivrn";
      exec = "wivrn-dashboard";
      type = "Application";
      categories = [ "Network" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/WiVRn/WiVRn/";
    changelog = "https://github.com/WiVRn/WiVRn/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      ImSapphire
      passivelemon
    ];
    platforms = lib.platforms.linux;
    mainProgram = "wivrn-server";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})
