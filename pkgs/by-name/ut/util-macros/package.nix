{
  lib,
  stdenv,
  fetchFromGitLab,
  testers,
  gitUpdater,
  autoreconfHook,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "util-macros";
  version = "1.20.2";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "util";
    repo = "macros";
    tag = "util-macros-${finalAttrs.version}";
    hash = "sha256-COIWe7GMfbk76/QUIRsN5yvjd6MEarI0j0M+Xa0WoKQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [ autoreconfHook ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater {
      rev-prefix = "util-macros-";
      ignoredVersions = "1_0_2";
    };
  };

  meta = {
    description = "GNU autoconf macros shared across X.Org projects";
    homepage = "https://gitlab.freedesktop.org/xorg/util/macros";
    license = with lib.licenses; [
      hpndSellVariant
      mit
    ];
    maintainers = with lib.maintainers; [
      raboof
      jopejoe1
    ];
    pkgConfigModules = [ "xorg-macros" ];
    platforms = lib.platforms.unix;
  };
})
