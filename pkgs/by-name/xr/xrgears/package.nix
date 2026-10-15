{
  SDL2,
  fetchFromGitLab,
  glib,
  glm,
  glslang,
  lib,
  libGL,
  makeWrapper,
  meson,
  ninja,
  openxr-loader,
  pkg-config,
  stdenv,
  unstableGitUpdater,
  vulkan-headers,
  vulkan-loader,
  xxd,
}:

stdenv.mkDerivation {
  pname = "xrgears";
  version = "1.0.1-unstable-2026-09-06";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "51ef6c779c8d3134d8df9eca1294779e61c8243f";
    sha256 = "sha256-/j23NgqazHNKIJuRa05bycnvizifTUhth5XXI7HUNCw=";
  };

  nativeBuildInputs = [
    glslang
    meson
    ninja
    pkg-config
    xxd
    makeWrapper
  ];

  buildInputs = [
    glm
    openxr-loader
    vulkan-headers
    vulkan-loader
    glib
  ];

  fixupPhase = ''
    wrapProgram $out/bin/xrgears \
      --prefix LD_LIBRARY_PATH : ${
        lib.makeLibraryPath [
          SDL2
          libGL
        ]
      }
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://gitlab.freedesktop.org/monado/demos/xrgears";
    description = "OpenXR example using Vulkan for rendering";
    mainProgram = "xrgears";
    platforms = lib.platforms.linux;
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Scrumplex ];
  };
}
