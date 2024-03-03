{ config
, lib
, stdenv
, fetchFromGitHub
, fetchFromGitLab
, fetchpatch
, avahi
, boost
, cmake
, cudaPackages ? { }
, cudaSupport ? config.cudaSupport
, eigen
, ffmpeg
, freetype
, git
, glm
, glslang
, harfbuzz
, libdrm
, libGL
, libva
, libpulseaudio
, libX11
, libXrandr
, nix-update-script
, nlohmann_json
, onnxruntime
, openxr-loader
, pipewire
, pkg-config
, python3
, shaderc
, spdlog
, systemd
, udev
, vulkan-headers
, vulkan-loader
, vulkan-tools
, x264
}:
let
  wivrnVersion = "0.15";

  wivrnSrc = fetchFromGitHub {
    owner = "meumeu";
    repo = "wivrn";
    rev = "v${wivrnVersion}";
    hash = "sha256-RVRbL9hqy9pMKjvzwaP+9HGEfdpAhmlnnvqZsEGxlCw=";
  };

  monadoVersion = builtins.head (builtins.elemAt (builtins.split
    "monado\n +GIT_TAG +([A-Za-z0-9]+)"
    (builtins.readFile (wivrnSrc + "/CMakeLists.txt"))
  ) 1);

  monado = stdenv.mkDerivation {
    pname = "monado";
    version = monadoVersion;

    src = fetchFromGitLab {
      domain = "gitlab.freedesktop.org";
      owner = "monado";
      repo = "monado";
      rev = monadoVersion;
      hash = "sha256-+RTHS9ShicuzhiAVAXf38V6k4SVr+Bc2xUjpRWZoB0c=";
    };

    patches = [
      (wivrnSrc + "/patches/monado/0001-c-multi-disable-dropping-of-old-frames.patch")
      (wivrnSrc + "/patches/monado/0002-ipc-server-Always-listen-to-stdin.patch")
      (wivrnSrc + "/patches/monado/0003-c-multi-Don-t-log-frame-time-diff.patch")
    ];

    postPatch = ''
      substituteInPlace CMakeLists.txt --replace "add_subdirectory(doc)" ""
    '';

    dontBuild = true;

    installPhase = ''
      cp -r . $out
    '';
  };
in
stdenv.mkDerivation {
  pname = "wivrn";
  version = wivrnVersion;

  src = wivrnSrc;

  nativeBuildInputs = [
    cmake
    git
    pkg-config
    python3
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    avahi
    boost
    eigen
    ffmpeg
    freetype
    glm
    glslang
    harfbuzz
    libdrm
    libGL
    libva
    libX11
    libXrandr
    libpulseaudio
    nlohmann_json
    onnxruntime
    openxr-loader
    pipewire
    shaderc
    spdlog
    systemd
    udev
    vulkan-headers
    vulkan-loader
    vulkan-tools
    x264
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    (lib.cmakeBool "WIVRN_USE_VAAPI" true)
    (lib.cmakeBool "WIVRN_USE_X264" true)
    (lib.cmakeBool "WIVRN_USE_NVENC" cudaSupport)
    (lib.cmakeBool "WIVRN_USE_SYSTEMD" true)
    (lib.cmakeBool "WIVRN_USE_PIPEWIRE" true)
    (lib.cmakeBool "WIVRN_USE_PULSEAUDIO" true)
    (lib.cmakeBool "WIVRN_BUILD_CLIENT" false)
    (lib.cmakeBool "WIVRN_OPENXR_INSTALL_ABSOLUTE_RUNTIME_PATH" true)
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_MONADO" "${monado}")
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "An OpenXR streaming application to a standalone headset";
    homepage = "https://github.com/Meumeu/WiVRn/";
    changelog = "https://github.com/Meumeu/WiVRn/releases/tag/v${wivrnVersion}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ passivelemon ];
    platforms = platforms.linux;
    mainProgram = "wivrn-server";
  };
}
