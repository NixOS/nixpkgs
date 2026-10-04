{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  fetchpatch,
  pkg-config,
  versionCheckHook,
  nix-update-script,
  boost,
  ffmpeg,
  glslang,
  llvmPackages,
  ncnn,
  spdlog,
  vulkan-headers,
  vulkan-loader,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "video2x";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "k4yt3x";
    repo = "video2x";
    tag = finalAttrs.version;
    hash = "sha256-DSsfGAkPOtqqj0FA1N33O+OYmv+CMUsrvmh5SrnF7eA=";
    fetchSubmodules = false;
    leaveDotGit = true;
    postFetch = ''
      pushd $out
      git reset --hard HEAD

      # Fetch the dependencies that nixpkgs cannot provide (non-recursive)
      git submodule update --init third_party/librealesrgan_ncnn_vulkan
      git submodule update --init third_party/librealcugan_ncnn_vulkan
      git submodule update --init third_party/librife_ncnn_vulkan

      # Cleanup
      rm -rf .git

      popd
    '';
  };

  patches = [
    # ncnn 20250916 removed Option::use_shader_pack8; drop RIFE's pack8 warp shader.
    # Remove when the librife_ncnn_vulkan submodule includes this commit.
    (fetchpatch {
      name = "librife-ncnn-vulkan-remove-pack8.patch";
      url = "https://github.com/k4yt3x/librife-ncnn-vulkan/commit/f1de3a97c49e1bed4a625aa8eef92586a4871e74.patch";
      stripLen = 1;
      extraPrefix = "third_party/librife_ncnn_vulkan/";
      excludes = [ "third_party/librife_ncnn_vulkan/src/ncnn" ];
      hash = "sha256-vqhi7vEhHDjz/vT4bTRMQiKIIhAI1ZhPsxnpWUcbIFQ=";
    })
  ];

  postPatch = ''
    substituteInPlace src/fsutils.cpp \
      --replace-fail '/usr/share/video2x' '${placeholder "out"}/share/video2x'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    glslang
  ];

  buildInputs = [
    boost
    ffmpeg
    ncnn
    spdlog
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optionals stdenv.cc.isClang [
    llvmPackages.openmp
  ];

  cmakeFlags = [
    # Don't build the libvideo2x shared library, we only need the CLI tool
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];

  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "AI-powered video upscaling tool";
    changelog = "https://github.com/k4yt3x/video2x/releases/tag/${finalAttrs.version}/CHANGELOG.md";
    homepage = "https://github.com/k4yt3x/video2x";
    license = lib.licenses.agpl3Plus;
    platforms = [ "x86_64-linux" ];
    mainProgram = "video2x";
    maintainers = [ lib.maintainers.matteopacini ];
  };
})
