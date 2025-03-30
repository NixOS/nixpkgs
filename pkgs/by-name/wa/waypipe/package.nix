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
}:
llvmPackages.stdenv.mkDerivation rec {
  pname = "waypipe";
  version = "0.10.3";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "mstoeckl";
    repo = "waypipe";
    tag = "v${version}";
    hash = "sha256-E0NJTOK8wf42dXgBtsOmCKlfSLC/zEuUxLKVxwcb9Ig=";
  };
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit pname version src;
    hash = "sha256-T2/su0DQt8KZ8diHTNz3jzeMZaW3cGcAFA6MYs1Qn3k=";
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
