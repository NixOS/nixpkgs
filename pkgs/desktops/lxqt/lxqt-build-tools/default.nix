{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qtbase,
  glib,
  perl,
  wrapQtAppsHook,
  gitUpdater,
  version ? "2.3.0",
}:

stdenv.mkDerivation rec {
  pname = "lxqt-build-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = "lxqt-build-tools";
    rev = version;
    hash =
      {
        "0.13.0" = "sha256-4/hVlEdqqqd6CNitCRkIzsS1R941vPJdirIklp4acXA=";
        "2.3.0" = "sha256-lbDcIOrOkGU/n0bPPAlZSsdBYMlBh3afXwwTkTWQLpo=";
      }
      ."${version}";
  };

  postPatch = ''
    # Nix clang on darwin identifies as 'Clang', not 'AppleClang'
    # Without this, dependants fail to link.
    substituteInPlace cmake/modules/LXQtCompilerSettings.cmake \
      --replace-fail AppleClang Clang
  ''
  + lib.optionalString (lib.versionOlder version "2.3.0") ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1.0 FATAL_ERROR)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    setupHook
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    glib
  ];

  propagatedBuildInputs = [
    perl # needed by LXQtTranslateDesktop.cmake
  ];

  setupHook = ./setup-hook.sh;

  # We're dependent on this macro doing add_definitions in most places
  # But we have the setup-hook to set the values.
  postInstall = ''
    cp ${./LXQtConfigVars.cmake} $out/share/cmake/lxqt${lib.optionalString (lib.versionAtLeast version "2.0.0") "2"}-build-tools/modules/LXQtConfigVars.cmake
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-build-tools";
    description = "Various packaging tools and scripts for LXQt applications";
    mainProgram = "lxqt-transupdate";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    teams = [ teams.lxqt ];
  };
}
