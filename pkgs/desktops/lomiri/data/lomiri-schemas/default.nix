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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-schemas";
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-schemas";
    rev = finalAttrs.version;
    hash = "sha256-FrDUFqdD0KW2VG2pTA6LMb6/9PdNtQUlYTEo1vnW6QQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # glib-compile-schemas
    pkg-config
    intltool
  ];

  buildInputs = [
    cmake-extras
    glib
  ];

  cmakeFlags = [
    "-DGSETTINGS_LOCALINSTALL=ON"
    "-DGSETTINGS_COMPILE=ON"
  ];

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "GSettings / AccountsService schema files for Lomiri";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-schemas";
    license = licenses.lgpl21Plus;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-schemas"
    ];
  };
})
