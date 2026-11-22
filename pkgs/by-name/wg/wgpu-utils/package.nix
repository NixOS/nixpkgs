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
  version = "30.0.2";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    tag = "wgpu-v${finalAttrs.version}";
    hash = "sha256-lFC9KoIPDdMEn8NbnEgv5B+BvWEGGi5osOdKS5Sjugo=";
  };

  # cargo-auditable fails on wgpu's dep:-based feature wiring.
  auditable = false;

  cargoHash = "sha256-+P1UdDVdZVktPi0EBZdmiXiW/swhWgeiV3RCyQ0F684=";

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
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [ erictapen ];
    mainProgram = "wgpu-info";
  };
})
