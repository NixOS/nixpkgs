{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, qtbase
, glib
, perl
, wrapQtAppsHook
, gitUpdater
, version ? "2.0.0"
}:

stdenv.mkDerivation rec {
  pname = "lxqt-build-tools";
  inherit version;

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = {
      "0.13.0" = "sha256-4/hVlEdqqqd6CNitCRkIzsS1R941vPJdirIklp4acXA=";
      "2.0.0" = "sha256-ZFvnIumP03Mp+4OHPe1yMVsSYhMmYUY1idJGCAy5IhA=";
    }."${version}";
  };

  postPatch = ''
    # Nix clang on darwin identifies as 'Clang', not 'AppleClang'
    # Without this, dependants fail to link.
    substituteInPlace cmake/modules/LXQtCompilerSettings.cmake \
      --replace-fail AppleClang Clang
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
    pcre
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
    maintainers = teams.lxqt.members;
  };
}
