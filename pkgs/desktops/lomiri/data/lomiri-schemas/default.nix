{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  glib,
  intltool,
  pkg-config,
  validatePkgConfig,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "lomiri-schemas";
  version = "0.1.9";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-schemas";
    tag = finalAttrs.version;
    hash = "sha256-qdkKQpKIad7bEMaN6q79byVTipuvUFSdCZQKdMtOERo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # glib-compile-schemas
    pkg-config
    intltool
    validatePkgConfig
  ];

  buildInputs = [
    cmake-extras
    glib
  ];

  cmakeFlags = [
    (lib.cmakeBool "GSETTINGS_LOCALINSTALL" true)
    (lib.cmakeBool "GSETTINGS_COMPILE" true)
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "GSettings / AccountsService schema files for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-schemas";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-schemas/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.lgpl21Plus;
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-schemas"
    ];
  };
})
