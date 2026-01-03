{
  autoreconfHook,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libiconv,
  libintl,
  stdenv,
  windows,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zvbi";
  version = "0.2.44";

  src = fetchFromGitHub {
    owner = "zapping-vbi";
    repo = "zvbi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-knc9PejugU6K4EQflfz91keZr3ZJqZu2TKFQFFJrxiI=";
  };

  patches = lib.optionals stdenv.hostPlatform.isMinGW [
    # MSYS2: mingw-w64-zvbi applies -no-undefined so shared libs can be built on MinGW.
    ./mingw-no-undefined.patch
  ];

  configureFlags =
    lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
      "ac_cv_func_malloc_0_nonnull=yes"
      "ac_cv_func_realloc_0_nonnull=yes"
    ]
    ++ lib.optionals stdenv.hostPlatform.isMinGW [
      # MSYS2 disables these for MinGW; also cross builds can't run them.
      "--disable-examples"
      "--disable-tests"
    ];

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    libiconv
    libintl
  ] ++ lib.optionals stdenv.hostPlatform.isMinGW [
    # libzvbi.h includes <pthread.h> on MinGW; consumers must see winpthreads headers.
    windows.pthreads
  ];

  env.NIX_LDFLAGS = lib.optionalString stdenv.hostPlatform.isMinGW "-lpthread";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  enableParallelBuilding = true;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Vertical Blanking Interval (VBI) utilities";
    homepage = "https://github.com/zapping-vbi/zvbi";
    changelog = "https://github.com/zapping-vbi/zvbi/blob/${finalAttrs.src.rev}/ChangeLog";
    pkgConfigModules = [ "zvbi-0.2" ];
    license = with lib.licenses; [
      bsd2
      bsd3
      gpl2
      gpl2Plus
      lgpl21Plus
      lgpl2Plus
      mit
    ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
