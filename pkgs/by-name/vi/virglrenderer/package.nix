{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  buildPackages,
  libGLU,
  libepoxy,
  libX11,
  libdrm,
  libgbm,
  nativeContextSupport ? stdenv.hostPlatform.isLinux,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin,
  libva,
  vulkanSupport ? stdenv.hostPlatform.isLinux,
  vulkan-headers,
  vulkan-loader,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "1.1.1";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/${version}/virglrenderer-${version}.tar.bz2";
    hash = "sha256-D+SJqBL76z1nGBmcJ7Dzb41RvFxU2Ak6rVOwDRB94rM=";
  };

  separateDebugInfo = true;

  buildInputs =
    [
      libepoxy
    ]
    ++ lib.optionals vaapiSupport [ libva ]
    ++ lib.optionals vulkanSupport [
      vulkan-headers
      vulkan-loader
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGLU
      libX11
      libdrm
      libgbm
    ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (buildPackages.python3.withPackages (ps: [
      ps.pyyaml
    ]))
  ];

  mesonFlags =
    [
      (lib.mesonBool "video" vaapiSupport)
      (lib.mesonBool "venus" vulkanSupport)
    ]
    ++ lib.optionals nativeContextSupport [
      (lib.mesonOption "drm-renderers" "amdgpu-experimental,msm")
    ];

  passthru = {
    updateScript = gitUpdater {
      url = "https://gitlab.freedesktop.org/virgl/virglrenderer.git";
      rev-prefix = "virglrenderer-";
    };
  };

  meta = with lib; {
    description = "Virtual 3D GPU library that allows a qemu guest to use the host GPU for accelerated 3D rendering";
    mainProgram = "virgl_test_server";
    homepage = "https://virgil3d.github.io/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = [ maintainers.xeji ];
  };
}
