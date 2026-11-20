{
  autoreconfHook,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libiconv,
  libintl,
  stdenv,
  testers,
  tzdata,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zvbi";
  version = "0.2.45";

  src = fetchFromGitHub {
    owner = "zapping-vbi";
    repo = "zvbi";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Nkg/Y7tHYAEi3ndbiJwwutVrGCOIE5RUCNQW3j12BkM=";
  };

  configureFlags = lib.optionals (!lib.systems.equals stdenv.buildPlatform stdenv.hostPlatform) [
    "ac_cv_func_malloc_0_nonnull=yes"
    "ac_cv_func_realloc_0_nonnull=yes"
  ];

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  propagatedBuildInputs = [
    libiconv
    libintl
  ];

  nativeCheckInputs = [
    tzdata
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ];

  enableParallelBuilding = true;

  doCheck =
    stdenv.buildPlatform.canExecute stdenv.hostPlatform
    && !stdenv.hostPlatform.isDarwin
    &&
      # musl does not support TZDIR, used by the tzdata setup hook.
      !stdenv.hostPlatform.isMusl;

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Vertical Blanking Interval (VBI) utilities";
    homepage = "https://github.com/zapping-vbi/zvbi";
    changelog = "https://github.com/zapping-vbi/zvbi/blob/${finalAttrs.src.rev}/ChangeLog";
    pkgConfigModules = [ "zvbi-0.2" ];
    license =
      with lib.licenses;
      AND [
        bsd2
        (OR [
          bsd3
          gpl2Plus
        ])
        gpl2Only
        gpl2Plus
        lgpl21Plus
        lgpl2Plus
        mit
      ];
    maintainers = with lib.maintainers; [ jopejoe1 ];
  };
})
