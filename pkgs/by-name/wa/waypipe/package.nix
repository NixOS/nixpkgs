{
  lib,
  rustPlatform,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  scdoc,
  libgbm,
  lz4,
  zstd,
  ffmpeg,
  cargo,
  rustc,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  llvmPackages,
  autoPatchelfHook,
  wayland-scanner,
  rust-bindgen,
  nix-update-script,
}:
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "waypipe";
  version = "0.10.4";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O47b1CHCEwUSigjk0Ml3uLhRRxcPC6Phj2cnIlX1Hkg=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-c561GpU2XENILSzk0Zka0qrtXZm7xaq/hiJA4Iv++QI=";
  };

  strictDeps = true;
  LIBCLANG_PATH = "${llvmPackages.libclang.lib}/lib";
  depsBuildBuild = [ pkg-config ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    cargo
    shaderc # for glslc
    rustc
    wayland-scanner
    rustPlatform.cargoSetupHook
    autoPatchelfHook
    rust-bindgen
  ];

  buildInputs = [
    libgbm
    lz4
    zstd
    ffmpeg
    vulkan-headers
    vulkan-loader
  ];

  runtimeDependencies = [
    libgbm
    ffmpeg.lib
    vulkan-loader
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Network proxy for Wayland clients (applications)";
    longDescription = ''
      waypipe is a proxy for Wayland clients. It forwards Wayland messages and
      serializes changes to shared memory buffers over a single socket. This
      makes application forwarding similar to ssh -X feasible.
    '';
    homepage = "https://mstoeckl.com/notes/gsoc/blog.html";
    changelog = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/releases#v${finalAttrs.version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ mic92 ];
    mainProgram = "waypipe";
  };
})
