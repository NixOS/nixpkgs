{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  moltenvk,
  vulkan-headers,
  vulkan-loader,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vkpeak";
  version = "0-unstable-2026-01-12";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "nihui";
    repo = "vkpeak";
    tag = "20260112";
    fetchSubmodules = true;
    hash = "sha256-m/qv8E8KqF4lr/xp0Bf8MMLSiPV8JQdID7NBEWhFjaA=";
  };

  postPatch = ''
    echo 'install(TARGETS vkpeak RUNTIME DESTINATION bin)' >> CMakeLists.txt
  '';

  cmakeFlags = [
    (lib.cmakeBool "GLSLANG_ENABLE_INSTALL" false)
  ];

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];

  buildInputs = [
    vulkan-headers
    vulkan-loader
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin moltenvk;

  postFixup =
    if stdenv.hostPlatform.isDarwin then
      ''
        wrapProgram $out/bin/vkpeak \
          --set-default NCNN_VULKAN_DRIVER ${moltenvk}/lib/libMoltenVK.dylib \
          --set-default VK_DRIVER_FILES ${moltenvk}/share/vulkan/icd.d/MoltenVK_icd.json
      ''
    else
      lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/vkpeak \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
      '';

  __structuredAttrs = true;

  meta = {
    description = "Synthetic benchmark for measuring peak capabilities of Vulkan devices";
    homepage = "https://github.com/nihui/vkpeak";
    license = lib.licenses.mit;
    mainProgram = "vkpeak";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ moeleak ];
  };
})
