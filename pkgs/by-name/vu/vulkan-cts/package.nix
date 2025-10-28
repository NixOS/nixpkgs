{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  runCommand,
  cmake,
  ffmpeg,
  glslang,
  libdrm,
  libglvnd,
  libffi,
  libpng,
  libX11,
  libXau,
  libXdmcp,
  libxcb,
  makeWrapper,
  mesa,
  ninja,
  pkg-config,
  python3,
  spirv-headers,
  vulkan-headers,
  vulkan-loader,
  vulkan-utility-libraries,
  wayland,
  wayland-protocols,
  wayland-scanner,
  zlib,
}:
let
  renderdoc = fetchurl {
    url = "https://raw.githubusercontent.com/baldurk/renderdoc/v1.1/renderdoc/api/app/renderdoc_app.h";
    hash = "sha256-57XwqlsbDq3GOhxiTAyn9a8TOqhX1qQnGw7z0L22ho4=";
  };

  # The build system expects all these dependencies inside the external folder and
  # does not search for system-wide installations.
  # It also expects the version specified in the repository, which can be incompatible
  # with the version in nixpkgs (e.g. for SPIRV-Headers), so we don't want to patch in our packages.
  # The revisions are extracted from https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/fetch_sources.py#L290
  # with the vk-cts-sources.py script.
  sources = import ./sources.nix { inherit fetchurl fetchFromGitHub; };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-cts";
  version = "1.4.3.3";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "VK-GL-CTS";
    rev = "vulkan-cts-${finalAttrs.version}";
    hash = "sha256-bhbk2ayY4syyUXJcYesRlVFArAVhivTjELvM8uuNzEQ=";
  };

  prePatch = ''
    mkdir -p external/renderdoc/src

    cp -r ${renderdoc} external/renderdoc/src/renderdoc_app.h

    ${sources.prePatch}

    substituteInPlace external/vulkan-validationlayers/CMakeLists.txt \
      --replace-fail 'UPDATE_DEPS ON' 'UPDATE_DEPS OFF'

    substituteInPlace external/vulkan-video-samples/src/cmake/FindVulkanSDK.cmake \
      --replace-fail 'GIT_TAG main' 'GIT_TAG main FIND_PACKAGE_ARGS NAMES VulkanHeaders'

    chmod u+w -R external
  '';

  buildInputs = [
    ffmpeg
    libdrm
    libffi
    libglvnd
    libpng
    libX11
    libXau
    libXdmcp
    libxcb
    vulkan-headers
    vulkan-utility-libraries
    wayland
    wayland-protocols
    zlib
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
    ninja
    pkg-config
    python3
    wayland-scanner
  ];

  depsBuildBuild = [
    pkg-config
  ];

  cmakeFlags = [
    # Fix cts cmake not coping with absolute install dirs
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"

    "-DWAYLAND_SCANNER=wayland-scanner"
    # For vulkan-validation-layers
    "-DGLSLANG_INSTALL_DIR=${glslang}"
    "-DSPIRV_HEADERS_INSTALL_DIR=${spirv-headers}"
    "-DSELECTED_BUILD_TARGETS=deqp-vk"
  ];

  postInstall = ''
    # Check that nothing was installed so far
    ! test -e $out

    mkdir -p $out/bin $out/archive-dir
    cp -a external/vulkancts/modules/vulkan/deqp-vk $out/bin/
    cp -a external/vulkancts/modules/vulkan/vulkan $out/archive-dir/
    cp -a external/vulkancts/modules/vulkan/vk-default $out/
  '';

  postFixup = ''
    patchelf --add-rpath "${vulkan-loader}/lib" --add-needed "libvulkan.so" $out/bin/deqp-vk
    wrapProgram $out/bin/deqp-vk \
      --add-flags "--deqp-archive-dir=$out/archive-dir"
  '';

  passthru.updateScript = ./update.sh;
  passthru.tests.lavapipe =
    runCommand "vulkan-cts-tests-lavapipe"
      {
        nativeBuildInputs = [
          finalAttrs.finalPackage
          mesa.llvmpipeHook
        ];
      }
      ''
        deqp-vk -n dEQP-VK.api.smoke.triangle
        touch $out
      '';

  meta = with lib; {
    description = "Khronos Vulkan Conformance Tests";
    homepage = "https://github.com/KhronosGroup/VK-GL-CTS/blob/main/external/vulkancts/README.md";
    changelog = "https://github.com/KhronosGroup/VK-GL-CTS/releases/tag/vulkan-cts-${finalAttrs.version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ Flakebi ];
  };
})
