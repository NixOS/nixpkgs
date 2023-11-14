{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, pcre
, qtbase
, glib
, perl
, gitUpdater
}:

mkDerivation rec {
  pname = "lxqt-build-tools";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-4/hVlEdqqqd6CNitCRkIzsS1R941vPJdirIklp4acXA=";
  };

  postPatch = ''
    # Nix clang on darwin identifies as 'Clang', not 'AppleClang'
    # Without this, dependants fail to link.
    substituteInPlace cmake/modules/LXQtCompilerSettings.cmake \
      --replace AppleClang Clang

    # GLib 2.72 moved the file from gio-unix-2.0 to gio-2.0.
    # https://github.com/lxqt/lxqt-build-tools/pull/74
    substituteInPlace cmake/find-modules/FindGLIB.cmake \
      --replace gio/gunixconnection.h gio/gunixfdlist.h
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    setupHook
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
    rm $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
    cp ${./LXQtConfigVars.cmake} $out/share/cmake/lxqt-build-tools/modules/LXQtConfigVars.cmake
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/lxqt-build-tools";
    description = "Various packaging tools and scripts for LXQt applications";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
