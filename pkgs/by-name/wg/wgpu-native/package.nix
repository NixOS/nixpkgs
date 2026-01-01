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
<<<<<<< HEAD
  version = "27.0.4.0";
=======
  version = "27.0.2.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu-native";
    tag = "v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-XOT6Wx5TfbFzwcSjoyqUwv7mbN0RShaMf99qADmCKxg=";
=======
    hash = "sha256-sJEDCt8DTP6FjtbROVCZVD0we0OA07wjkiLnXoQfTuc=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

<<<<<<< HEAD
  cargoHash = "sha256-PZHS2lUX6PbIG1xF6jhreGjdtCbS/GWeY1pHhRPo2aU=";
=======
  cargoHash = "sha256-ZQiX7IZsbjlDzRNlYgpRnLfCKGAYnSwvACRMNkZPjbE=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
