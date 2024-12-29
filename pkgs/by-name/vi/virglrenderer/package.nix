{
  lib,
  stdenv,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  python3,
  libGLU,
  libepoxy,
  libX11,
  libdrm,
  libgbm,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin,
  libva,
  withVenus ? !stdenv.hostPlatform.isDarwin,
  vulkan-headers,
  vulkan-loader,
  gitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "virglrenderer";
  version = "1.1.0";

  src = fetchurl {
    url = "https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/${version}/virglrenderer-${version}.tar.bz2";
    hash = "sha256-XGgKst7ENLKCUv0jU/HiEtTYe+7b9sHnSufj0PZVsb0=";
  };

  separateDebugInfo = true;

  buildInputs =
    [ libepoxy ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libGLU
      libX11
      libdrm
      libgbm
    ]
    ++ lib.optionals vaapiSupport [ libva ]
    ++ lib.optionals withVenus [ vulkan-loader ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    python3
  ] ++ lib.optionals withVenus [ vulkan-headers ];

  mesonFlags = [
    (lib.mesonBool "video" vaapiSupport)
    (lib.mesonBool "venus" withVenus)
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
