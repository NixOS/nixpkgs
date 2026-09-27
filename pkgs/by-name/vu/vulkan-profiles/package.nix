{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  vulkan-headers,
  vulkan-utility-libraries,
  valijson,
  jsoncpp,
  gtest,
  vulkan-loader,
  vulkan-tools,
  mesa,
  runCommand,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "vulkan-profiles";
  version = "1.4.357.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "Vulkan-Profiles";
    tag = "vulkan-sdk-${finalAttrs.version}";
    hash = "sha256-980RALIOpGw4JwkgcFni+zqlfLENGeKkmLr8cQkxAO4=";
  };

  nativeBuildInputs = [
    cmake
    (python3.withPackages (
      ps: with ps; [
        jsonschema
        pyinstaller
        pyparsing
      ]
    ))
  ];

  buildInputs = [
    vulkan-headers
    vulkan-utility-libraries
    valijson
    # Upstream links against the static jsoncpp_static target, which nixpkgs
    # only builds when explicitly requested.
    (jsoncpp.override { enableStatic = true; })
    gtest
    vulkan-loader
  ];

  strictDeps = true;

  cmakeFlags = [
    "-DUPDATE_DEPS=OFF"
    "-DBUILD_TESTS=ON"
    "-DVULKAN_HEADERS_INSTALL_DIR=${vulkan-headers}"
  ];

  nativeCheckInputs = [ mesa ];

  doCheck = true;

  # Tests create real VkInstance/VkDevice objects; point loader at Lavapipe
  # (CPU software rasterizer) since the sandbox has no GPU/ICD.
  preCheck = ''
    export VK_ICD_FILENAMES="${mesa}/share/vulkan/icd.d/lvp_icd.${stdenv.hostPlatform.parsed.cpu.name}.json"
    export LD_LIBRARY_PATH="${
      lib.makeLibraryPath [ vulkan-loader ]
    }''${LD_LIBRARY_PATH:+:}$LD_LIBRARY_PATH"
  '';

  postInstall = ''
    substituteInPlace $out/share/vulkan/explicit_layer.d/VkLayer_khronos_profiles.json \
      --replace-fail '"library_path": "libVkLayer_khronos_profiles.so"' \
                      '"library_path": "${placeholder "out"}/lib/libVkLayer_khronos_profiles.so"'
  '';

  passthru = {
    tests.layer-loads =
      runCommand "vulkan-profiles-layer-loads" { nativeBuildInputs = [ vulkan-tools ]; }
        ''
          export VK_ICD_FILENAMES="${mesa}/share/vulkan/icd.d/lvp_icd.${stdenv.hostPlatform.parsed.cpu.name}.json"
          export VK_LAYER_PATH="${finalAttrs.finalPackage}/share/vulkan/explicit_layer.d"
          vulkaninfo > vulkaninfo.log 2>&1 || { cat vulkaninfo.log; exit 1; }
          grep -q "VK_LAYER_KHRONOS_profiles (Khronos Profiles layer)" vulkaninfo.log || {
            echo "layer did not load:"; cat vulkaninfo.log; exit 1;
          }
          touch $out
        '';
  };

  __structuredAttrs = true;

  meta = {
    description = "Khronos toolset for building portable Vulkan applications using Vulkan Profiles";
    homepage = "https://github.com/KhronosGroup/Vulkan-Profiles";
    license = with lib.licenses; [
      asl20
      cc-by-40
    ];
    # doCheck and passthru.tests.layer-loads assume Mesa's Lavapipe (lvp) ICD,
    # which only exists on Linux; Darwin's `mesa` builds "kosmickrisp" instead.
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.xdan7 ];
  };
})
