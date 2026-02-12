{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  cmake,
  makeWrapper,
  vulkan-loader,
  freetype,
  fontconfig,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wgpu-utils";
  version = "25.0.2";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    tag = "wgpu-v${finalAttrs.version}";
    hash = "sha256-Na8UWMEzY0mvw8YERZ86PH79Z5YlXITPdOYha7Ahn7k=";
  };

  cargoHash = "sha256-9o1Tb0pVTc3iWPjNlAPBQX72djcx3EPJhxuUW6xZfCs=";

  nativeBuildInputs = [
    pkg-config
    cmake
    makeWrapper
  ];

  buildInputs = [
    freetype
    fontconfig
  ];

  # Tests fail, as the Nix sandbox doesn't provide an appropriate adapter (e.g. Vulkan).
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/wgpu-info \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    description = "Safe and portable GPU abstraction in Rust, implementing WebGPU API";
    homepage = "https://wgpu.rs/";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "wgpu-info";
  };
})
