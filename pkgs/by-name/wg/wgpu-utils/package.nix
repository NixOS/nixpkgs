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

rustPlatform.buildRustPackage rec {
  pname = "wgpu-utils";
  version = "24.0.3";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu";
    tag = "wgpu-v${version}";
    hash = "sha256-MoHpMdOKwCdQ2iO4O8WDskOQXgeFwpsD/UhQOhSbF70=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-l7V8awY17YxVyBzWV+BHRva7FczZQxJy8c6xve27gjs=";

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

  meta = with lib; {
    description = "Safe and portable GPU abstraction in Rust, implementing WebGPU API";
    homepage = "https://wgpu.rs/";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ erictapen ];
    mainProgram = "wgpu-info";
  };
}
