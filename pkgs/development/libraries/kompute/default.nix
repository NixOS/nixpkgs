{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  vulkan-headers,
  vulkan-loader,
  fmt,
  glslang,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "kompute";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "KomputeProject";
    repo = "kompute";
    rev = "v${version}";
    hash = "sha256-cf9Ef85R+VKao286+WHLgBWUqgwvuRocgeCzVJOGbdc=";
  };

  cmakeFlags = [
    "-DKOMPUTE_OPT_INSTALL=1"
    "-DRELEASE=1"
    "-DKOMPUTE_ENABLE_SPDLOG=1"
    # Build everything from source
    "-DKOMPUTE_OPT_BUILD_SHADERS=1"
    "-DKOMPUTE_OPT_USE_BUILT_IN_VULKAN_HEADER=0"
    "-DKOMPUTE_OPT_USE_BUILT_IN_FMT=0"
    # No GPU in the builder environment
    "-DKOMPUTE_OPT_DISABLE_VULKAN_VERSION_CHECK=1"
  ];

  nativeBuildInputs = [
    cmake
    ninja
  ];

  propagatedBuildInputs = [
    fmt
    glslang
    vulkan-headers
    vulkan-loader
  ];

  meta = with lib; {
    description = "General purpose GPU compute framework built on Vulkan";
    longDescription = ''
      General purpose GPU compute framework built on Vulkan to
      support 1000s of cross vendor graphics cards (AMD,
      Qualcomm, NVIDIA & friends). Blazing fast, mobile-enabled,
      asynchronous and optimized for advanced GPU data
      processing usecases. Backed by the Linux Foundation"
    '';
    homepage = "https://kompute.cc/";
    license = licenses.asl20;
    maintainers = with maintainers; [ atila ];
    platforms = platforms.linux;
  };
}
