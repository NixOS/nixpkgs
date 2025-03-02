{
  lib,
  clangStdenv,
  cmake,
  fetchFromGitHub,
  pkg-config,
  versionCheckHook,
  gitUpdater,
  boost,
  ffmpeg,
  glslang,
  llvmPackages,
  ncnn,
  shaderc,
  spdlog,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
}:
let
  librealcugan_ncnn_vulkan = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "librealcugan-ncnn-vulkan";
    rev = "d9c5a7eb4c8475af6110496c27c3d1f702f9b96a";
    hash = "sha256-PPoAAjtIbA16u0n2S0Bn6NBd4LYAovqFf5jDyuN6gsE=";
  };
  librealesrgan-ncnn-vulkan = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "librealesrgan-ncnn-vulkan";
    rev = "c1f255524f79566c40866b38e5e65b40adf77eee";
    hash = "sha256-0+oudxABQxwLHZFueoPkYlofUOzMUSd0dOhRXOdxrcA=";
  };
  librife-ncnn-vulkan = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "librife-ncnn-vulkan";
    rev = "3f7bcb44f38b2acda6fa5e575a6d12517ac16b94";
    hash = "sha256-tlRLUSmPz4H81TGkvcEUsJeQbxi+CRaQhCKmUl0JZi4=";
  };
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "video2x";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "video2x";
    tag = finalAttrs.version;
    hash = "sha256-arl4+fr8CwSN/Frw1jYZpuNUAa7BfJ9ffopKdoUTRc4=";
  };

  postPatch = ''
    substituteInPlace src/fsutils.cpp \
      --replace-fail '/usr/share/video2x' '${placeholder "out"}/share/video2x'
  '';

  postUnpack = ''
    # Use Nix dependencies instead (spdlog, boost and ncnn)
    rm -rf source/third_party/*
    # Get and link the remaining dependencies
    ln -s ${librealcugan_ncnn_vulkan} source/third_party/librealcugan_ncnn_vulkan
    ln -s ${librealesrgan-ncnn-vulkan} source/third_party/librealesrgan_ncnn_vulkan
    ln -s ${librife-ncnn-vulkan} source/third_party/librife_ncnn_vulkan
  '';

  nativeBuildInputs = [
    boost
    cmake
    ffmpeg.dev
    glslang
    llvmPackages.openmp
    ncnn
    pkg-config
    shaderc
    spdlog
    vulkan-headers
    vulkan-loader
    vulkan-tools
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  versionCheckProgramArg = [ "--version" ];
  doInstallCheck = true;

  passthru = {
    updateScript = gitUpdater { };
  };

  meta = {
    description = "AI-powered video upscaling tool";
    changelog = "https://github.com/k4yt3x/video2x/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/k4yt3x/video2x";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "video2x";
    maintainers = [ lib.maintainers.matteopacini ];
  };
})
