{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cmake,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "vulkan-memory-allocator";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "GPUOpen-LibrariesAndSDKs";
    repo = "VulkanMemoryAllocator";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LBZJcom7G7maF9wpUVeVEJQAJwGy6365INk3VD0/0PM=";
  };

  # A compiler is only required for the samples. This lets us use stdenvNoCC.
  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-warn 'LANGUAGES CXX' 'LANGUAGES NONE'
  '';

  nativeBuildInputs = [
    cmake
  ];

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Easy to integrate Vulkan memory allocation library";
    homepage = "https://gpuopen.com/vulkan-memory-allocator/";
    changelog = "https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "vulkan-memory-allocator";
    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
})
