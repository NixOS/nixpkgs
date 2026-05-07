{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fixDarwinDylibNames,
  vulkan-loader,
  nix-update-script,
  callPackage,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wgpu-native";
  version = "27.0.4.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu-native";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XOT6Wx5TfbFzwcSjoyqUwv7mbN0RShaMf99qADmCKxg=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoHash = "sha256-PZHS2lUX6PbIG1xF6jhreGjdtCbS/GWeY1pHhRPo2aU=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
  ];

  env.WGPU_NATIVE_VERSION = finalAttrs.version;

  postInstall = ''
    rm $out/lib/libwgpu_native.a
    install -Dm644 ./ffi/wgpu.h -t $dev/include/webgpu
    install -Dm644 ./ffi/webgpu-headers/webgpu.h -t $dev/include/webgpu
  '';

  passthru = {
    updateScript = nix-update-script { };
    examples = callPackage ./examples.nix {
      inherit (finalAttrs) version src;
    };
  };

  meta = {
    description = "Native WebGPU implementation based on wgpu-core";
    homepage = "https://github.com/gfx-rs/wgpu-native";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ niklaskorz ];
  };
})
