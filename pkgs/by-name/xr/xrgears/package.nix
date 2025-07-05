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
  version = "1.0.1-unstable-2025-03-03";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "caa21e13c2de83d33fb617c8f9b70a0d77c82453";
    sha256 = "sha256-VAcH+3yokDnUbFYldQOrkUi+WgcTnk6gBeKScyAyv6c=";
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

  meta = with lib; {
    homepage = "https://gitlab.freedesktop.org/monado/demos/xrgears";
    description = "OpenXR example using Vulkan for rendering";
    mainProgram = "xrgears";
    platforms = platforms.linux;
    license = licenses.mit;
    maintainers = with maintainers; [ Scrumplex ];
  };
}
