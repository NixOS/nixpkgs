{
  lib,
  callPackage,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  python3,
  jq,
  glslang,
  libffi,
  libx11,
  libxau,
  libxcb,
  libxdmcp,
  libxrandr,
  spirv-headers,
  spirv-tools,
  vulkan-headers,
  vulkan-utility-libraries,
  wayland,
}:

let
  robin-hood-hashing = callPackage ./robin-hood-hashing.nix { };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-validation-layers";
  version = "1.4.335.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-ValidationLayers";
    rev = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-FRxr33epHe+HIH/7Y7ms+6E9L0yzaNnFzN3YnswZfRo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    jq
  ];

  buildInputs = [
    glslang
    robin-hood-hashing
    spirv-headers
    spirv-tools
    vulkan-headers
    vulkan-utility-libraries
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libx11
    libxau
    libxdmcp
    libxrandr
    libffi
    libxcb
    wayland
  ];

  cmakeFlags = [
    "-DBUILD_LAYER_SUPPORT_FILES=ON"
    # Hide dev warnings that are useless for packaging
    "-Wno-dev"
  ];

  # Tests require access to vulkan-compatible GPU, which isn't
  # available in Nix sandbox. Fails with VK_ERROR_INCOMPATIBLE_DRIVER.
  doCheck = false;

  separateDebugInfo = true;

  # Include absolute paths to layer libraries in their associated
  # layer definition json files.
  preFixup = ''
    for f in "$out"/share/vulkan/explicit_layer.d/*.json "$out"/share/vulkan/implicit_layer.d/*.json; do
      jq <"$f" >tmp.json ".layer.library_path = \"$out/lib/\" + .layer.library_path"
      mv tmp.json "$f"
    done
  '';

  meta = {
    description = "Official Khronos Vulkan validation layers";
    homepage = "https://github.com/KhronosGroup/Vulkan-ValidationLayers";
    platforms = lib.platforms.all;
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.ralith ];
  };
})
