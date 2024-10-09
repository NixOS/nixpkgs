{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, testers
, cmake
, cmake-extras
, glib
, intltool
, pkg-config
, validatePkgConfig
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-schemas";
  version = "0.1.5";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-schemas";
    rev = finalAttrs.version;
    hash = "sha256-OjSMt9XKqGoStF5O2zJTh3drHWe7Vk2cM94OYMSQmoU=";
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

  meta = with lib; {
    description = "GSettings / AccountsService schema files for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-schemas";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-schemas/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl21Plus;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-schemas"
    ];
  };
})
