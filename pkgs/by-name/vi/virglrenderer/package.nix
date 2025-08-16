{
  lib,
  stdenv,
  fetchgit,
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
  vulkanSupport ? stdenv.hostPlatform.isLinux || stdenv.hostPlatform.isDarwin,
  vulkan-headers,
  vulkan-loader,
  gitUpdater,
  moltenvk,
}:

stdenv.mkDerivation {
  pname = "virglrenderer";
  version = "1.1.1";

  src = fetchgit {
    url = "https://gitlab.freedesktop.org/slp/virglrenderer.git";
    rev = "d9752dd5fd4172e8a5694bbfb72be0e0a51f9ef3";
    hash = "sha256-ANGduHj+QYf8fVTLiT82qlPpFBA6fhukYtWa2gvZg6E=";
  };

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace meson.build \
      --replace-fail "libdrm_dep = dependency('libdrm', version : '>=2.4.50', required: get_option('drm').enabled())" "" \
      --replace-fail "libdrm_dep.found()" "0"
    substituteInPlace src/meson.build \
      --replace-fail "libdrm_dep," ""
  '';

  separateDebugInfo = true;

  buildInputs = [
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
  ]
  ++ lib.optionals (stdenv.hostPlatform.isDarwin && vulkanSupport) [ moltenvk ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (buildPackages.python3.withPackages (ps: [
      ps.pyyaml
    ]))
  ];

  mesonFlags = [
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
