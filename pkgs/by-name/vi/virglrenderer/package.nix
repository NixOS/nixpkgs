{
  lib,
  stdenv,
  fetchFromGitLab,
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
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virglrenderer";
  version = "1.1.1";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "virgl";
    repo = "virglrenderer";
    tag = finalAttrs.version;
    hash = "sha256-ah6+AAf7B15rPMb4uO873wieT3+gf/5iGH+ZFoZKAAI=";
  };

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
  ];

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
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Virtual 3D GPU for use inside QEMU virtual machines";
    homepage = "https://docs.mesa3d.org/drivers/virgl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      normalcea
    ];
    mainProgram = "virgl_test_server";
    platforms = lib.platforms.unix;
  };
})
