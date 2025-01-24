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
  version = "1.0.1-unstable-2024-07-09";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "monado";
    repo = "demos/xrgears";
    rev = "9cabbd34b1f60f27402a9a50fc260f77a41b835b";
    sha256 = "sha256-9VV1zAOZKkl1zzjnsQQQOINi+T+wpbltdWpJ/d66+cM=";
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
