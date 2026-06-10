{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fixDarwinDylibNames,
  vulkan-loader,
  nix-update-script,
  callPackage,
  makePkgconfigItem,
  copyPkgconfigItems,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "wgpu-native";
  version = "29.0.0.0";

  src = fetchFromGitHub {
    owner = "gfx-rs";
    repo = "wgpu-native";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XaNNqQ7YcAuINSrG0Ri8qRA7b5iJPTbTKlFutKw2MQU=";
    fetchSubmodules = true;
  };

  outputs = [
    "out"
    "dev"
  ];

  cargoHash = "sha256-M0yQhKqs1ifOlh5yDsajMH3P2Qj2rUIqrhUhyl1FKV4=";

  nativeBuildInputs = [
    rustPlatform.bindgenHook
    copyPkgconfigItems
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin fixDarwinDylibNames;

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    vulkan-loader
  ];

  pkgconfigItems = [
    (makePkgconfigItem {
      name = "wgpu-native";
      inherit (finalAttrs) version;
      inherit (finalAttrs.meta) description;
      libs = [
        "-L\${libdir}"
        "-lwgpu_native"
      ];
      cflags = [ "-I\${includedir}" ];
      variables = {
        includedir = "@includedir@";
        libdir = "@libdir@";
      };
    })
  ];

  env = {
    WGPU_NATIVE_VERSION = finalAttrs.version;
    # copyPkgconfigItems will substitute these in the pkg-config file
    includedir = "${placeholder "dev"}/include";
    libdir = "${placeholder "out"}/lib";
  };

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
