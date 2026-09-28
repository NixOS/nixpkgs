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
  version = "29.0.1";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    tag = "wgpu-v${finalAttrs.version}";
    hash = "sha256-BLw1HnB0DghtWAe8jo6GPO54U3qNNO4yprArme1CdeE=";
  };

  # cargo-auditable fails on wgpu's dep:-based feature wiring.
  auditable = false;

  cargoHash = "sha256-QMH5GHjOHbzYdFUQxJ6aEQ+rX6Okl1HYog0hMh6bc8w=";

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
