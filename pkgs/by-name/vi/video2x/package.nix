{
  stdenv,
  lib,
  moltenvk,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ffmpeg,
  ncnn,
  spdlog,
  vulkan-headers,
  vulkan-loader,
  vulkan-tools,
  shaderc,
  glslang,
  boost,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "video2x";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "video2x";
    rev = "${finalAttrs.version}";
    hash = "sha256-arl4+fr8CwSN/Frw1jYZpuNUAa7BfJ9ffopKdoUTRc4=";
  };

  postUnpack = ''
    # Use Nix dependencies instead
    rm -rf source/third_party/*
    ln -s ${librealcugan_ncnn_vulkan} source/third_party/librealcugan_ncnn_vulkan
    ln -s ${librealesrgan-ncnn-vulkan} source/third_party/librealesrgan_ncnn_vulkan
    ln -s ${librife-ncnn-vulkan} source/third_party/librife_ncnn_vulkan
  '';

  nativeBuildInputs =
    [
      cmake
      pkg-config
      ffmpeg.dev
      ncnn
      spdlog
      boost
      vulkan-headers
      vulkan-loader
      vulkan-tools
      shaderc
      glslang
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      moltenvk
    ];

  meta = {
    description = "AI-powered video upscaling tool";
    changelog = "https://github.com/k4yt3x/video2x/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/k4yt3x/video2x";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.unix;
    mainProgram = "video2x";
  };
})
