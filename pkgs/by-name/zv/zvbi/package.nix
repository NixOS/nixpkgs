{
  autoreconfHook,
  fetchFromGitHub,
  gitUpdater,
  lib,
  libiconv,
  stdenv,
  testers,
  validatePkgConfig,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "zvbi";
  version = "0.2.42";

  src = fetchFromGitHub {
    owner = "zapping-vbi";
    repo = "zvbi";
    rev = "refs/tags/v${finalAttrs.version}";
    hash = "sha256-IeSGscgz51IndX6Xbu8Kw8GcJ9MLXXFhV+4LvnVkrLE=";
  };

  nativeBuildInputs = [
    autoreconfHook
    validatePkgConfig
  ];

  buildInputs = lib.optional stdenv.isDarwin libiconv;

  outputs = [
    "out"
    "dev"
    "man"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    description = "Vertical Blanking Interval (VBI) utilities";
    homepage = "https://github.com/zapping-vbi/zvbi";
    changelog = "https://github.com/zapping-vbi/zvbi/blob/v${finalAttrs.version}/ChangeLog";
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
