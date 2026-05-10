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
  libx11,
  libdrm,
  libgbm,
  libva,
  vulkan-headers,
  vulkan-loader,
  nix-update-script,
  vulkanSupport ? stdenv.hostPlatform.isLinux,
  nativeContextSupport ? stdenv.hostPlatform.isLinux,
  vaapiSupport ? !stdenv.hostPlatform.isDarwin,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "virglrenderer";
  version = "1.3.0";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    owner = "virgl";
    repo = "virglrenderer";
    tag = finalAttrs.version;
    hash = "sha256-2RoKIjtxShJCaezbkCrtW+lSaWKnOoUZzpSEPCJHSC8=";
  };

  separateDebugInfo = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    (buildPackages.python3.withPackages (ps: [
      ps.pyyaml
    ]))
  ];

  buildInputs = [
    libepoxy
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libGLU
    libx11
    libdrm
    libgbm
  ]
  ++ lib.optionals vaapiSupport [
    libva
  ]
  ++ lib.optionals vulkanSupport [
    vulkan-headers
    vulkan-loader
  ];

  mesonFlags = [
    (lib.mesonBool "video" vaapiSupport)
    (lib.mesonBool "venus" vulkanSupport)
    (lib.mesonOption "drm-renderers" (
      lib.optionalString nativeContextSupport (
        lib.concatStringsSep "," [
          "amdgpu-experimental"
          "asahi"
          "msm"
        ]
      )
    ))
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Virtual 3D GPU for use inside QEMU virtual machines";
    homepage = "https://docs.mesa3d.org/drivers/virgl";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "virgl_test_server";
    platforms = lib.platforms.unix;
  };
})
