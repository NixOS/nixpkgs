{
  stdenvNoCC,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.1.6";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-schemas";
    rev = finalAttrs.version;
    hash = "sha256-hCKsjZ2xW+Jimm8IT6E6ZaPGwXydiNTxyaHxY0gOEpg=";
  };

  patches = [
    # Remove when version > 0.1.6
    (fetchpatch {
      name = "0001-lomiri-schemas-Declare-no-compilers-needed.patch";
      url = "https://gitlab.com/ubports/development/core/lomiri-schemas/-/commit/6eec0513d2348dcfe49ce5969a091584888a79e5.patch";
      hash = "sha256-pbHNeP28WQ9wDdRkgsS8WY24ZKLS3G3h4gEd22DPuH8=";
    })
  ];

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
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-schemas"
    ];
  };
})
