{
  lib,
  rustPlatform,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  scdoc,
  mesa,
  lz4,
  zstd,
  ffmpeg,
  libva,
  cargo,
  rustc,
  git,
  vulkan-headers,
  vulkan-loader,
  shaderc,
  vulkan-tools,
  llvmPackages,
  autoPatchelfHook,
  wayland,
  wayland-scanner,
  rust-bindgen,
  egl-wayland,
}:
llvmPackages.stdenv.mkDerivation rec {
  pname = "waypipe";
  version = "0.10.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    tag = "v${version}";
    hash = "sha256-OV0FHieHce83W2O379VpGmUMrtID7NdtIrxIe+IJfF0=";
  };
  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit pname version src;
    hash = "sha256-pC1m1P4wJOT3jARGlpc86u7GdyPXX+YHsFLOcWRqdxI=";
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
    git
    vulkan-headers
    vulkan-loader
    shaderc
    rustc
    wayland-scanner
    rustPlatform.cargoSetupHook
    autoPatchelfHook
    rust-bindgen
  ];
  buildInputs = [
    # Optional dependencies:
    mesa
    lz4
    zstd
    ffmpeg
    libva
    vulkan-headers
  ];
  runtimeDependencies = [
    vulkan-tools
    vulkan-loader
    wayland
    egl-wayland
  ];

  meta = with lib; {
    description = "Network proxy for Wayland clients (applications)";
    longDescription = ''
      waypipe is a proxy for Wayland clients. It forwards Wayland messages and
      serializes changes to shared memory buffers over a single socket. This
      makes application forwarding similar to ssh -X feasible.
    '';
    homepage = "https://mstoeckl.com/notes/gsoc/blog.html";
    changelog = "https://gitlab.freedesktop.org/mstoeckl/waypipe/-/releases#v${version}";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ mic92 ];
    mainProgram = "waypipe";
  };
}
