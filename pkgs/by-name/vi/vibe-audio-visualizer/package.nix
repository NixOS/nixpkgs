{
  rustPlatform,
  lib,
  pkg-config,
  fetchFromGitHub,
  alsa-lib,
  libGL,
  libxkbcommon,
  wayland,
  libgbm,
  vulkan-loader,
  vulkan-validation-layers,
  vulkan-tools,
  makeWrapper,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "vibe-audio-visualizer";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "TornaxO7";
    repo = "vibe";
    tag = "vibe-v${finalAttrs.version}";
    hash = "sha256-zyPcEixrn0C2xpXeonaTWGaG0h72Qm4m1GrPv8YVdWo=";
  };

  cargoHash = "sha256-6FV1tJAkk8nCeA6q/RMim4AvFsZI4BrgRbUrucaGYkE=";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    wayland
    libGL
    libxkbcommon
    vulkan-loader
    vulkan-validation-layers
    vulkan-tools
    libgbm
  ];

  # tests require a gpu (which requires `hardware.graphics.enable = true`)
  doCheck = false;

  postInstall = ''
    wrapProgram $out/bin/vibe \
      --suffix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          # Without wayland in library path, this warning is raised:
          # "No windowing system present. Using surfaceless platform"
          wayland
          # Without vulkan-loader present, wgpu won't find any adapter
          vulkan-loader
          libgbm
        ]
      }
  '';

  meta = {
    description = "Wayland desktop audio visualizer";
    homepage = "https://github.com/TornaxO7/vibe";
    license = lib.licenses.agpl3Plus;
    mainProgram = "vibe";
    maintainers = with lib.maintainers; [ tornax ];
    platforms = lib.platforms.linux;
  };
})
