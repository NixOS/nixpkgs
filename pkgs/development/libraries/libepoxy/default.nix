{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  utilmacros,
  python3,
  libGL,
  libX11,
  Carbon,
  OpenGL,
  x11Support ? !stdenv.hostPlatform.isDarwin,
  waylandSupport ? stdenv.hostPlatform.isLinux,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libepoxy";
  version = "1.5.10";

  src = fetchFromGitHub {
    owner = "anholt";
    repo = "libepoxy";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-gZiyPOW2PeTMILcPiUTqPUGRNlMM5mI1z9563v4SgEs=";
  };

  patches = [ ./libgl-path.patch ];

  postPatch =
    ''
      patchShebangs src/*.py
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace src/dispatch_common.h --replace "PLATFORM_HAS_GLX 0" "PLATFORM_HAS_GLX 1"
    ''
    # cgl_core and cgl_epoxy_api fail in darwin sandbox and on Hydra (because it's headless?)
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      substituteInPlace test/meson.build \
        --replace "[ 'cgl_epoxy_api', [ 'cgl_epoxy_api.c' ] ]," ""
    ''
    + lib.optionalString (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64) ''
      substituteInPlace test/meson.build \
        --replace "[ 'cgl_core', [ 'cgl_core.c' ] ]," ""
    '';

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    utilmacros
    python3
    validatePkgConfig
  ];

  buildInputs =
    lib.optionals ((waylandSupport || x11Support) && !stdenv.hostPlatform.isDarwin) [
      libGL
    ]
    ++ lib.optionals x11Support [
      libX11
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      Carbon
      OpenGL
    ];

  mesonFlags = [
    (lib.mesonOption "egl" (if ((waylandSupport || x11Support) && !stdenv.hostPlatform.isDarwin) then "yes" else "no"))
    (lib.mesonOption "glx" (if x11Support then "yes" else "no"))
    (lib.mesonBool "tests" finalAttrs.finalPackage.doCheck)
    (lib.mesonBool "x11" x11Support)
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString (
    (waylandSupport || x11Support) && !stdenv.hostPlatform.isDarwin
  ) ''-DLIBGL_PATH="${lib.getLib libGL}/lib"'';

  doCheck = true;

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Library for handling OpenGL function pointer management";
    homepage = "https://github.com/anholt/libepoxy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jwillikers ];
    platforms = lib.platforms.unix;
    pkgConfigModules = [ "epoxy" ];
  };
})
