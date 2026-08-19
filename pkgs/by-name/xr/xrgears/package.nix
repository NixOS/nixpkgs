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
  version = "1.0.1-unstable-2026-01-20";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "034d3dbb17beb4e393f1524a8508fb353bafebea";
    sha256 = "sha256-nbAwR4bFBSv2tYJgX3uH318uyRGfz9Qxsj+bAxagqIg=";
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
