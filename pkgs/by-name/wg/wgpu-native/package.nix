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

rustPlatform.buildRustPackage rec {
  pname = "wgpu-native";
  version = "24.0.0.2";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu-native";
    tag = "v${version}";
    hash = "sha256-3Z9LBmFBVZD8e65OwBuzg1S/q/5Qq9Zu0tjiWPm2inc=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-F+EQVg2Ud/nzrWBbsLo9pCS2nfubaicyI/njDbcFtWo=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
  ] ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
  ];

  postInstall = ''
    rm $out/lib/libwgpu_native.a
    install -Dm644 ./ffi/wgpu.h -t $dev/include/webgpu
    install -Dm644 ./ffi/webgpu-headers/webgpu.h -t $dev/include/webgpu
  '';

  passthru = {
    updateScript = nix-update-script { };
    examples = callPackage ./examples.nix {
      inherit version src;
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
}
