{ lib
, stdenv
, mkDerivation
, fetchpatch
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
  version = "0.11.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "vzppKTDwADBG5pOaluT858cWCKFFRaSbHz2Qhe6799E=";
  };

  patches = [
    # in master post 0.11.0, see https://github.com/lxqt/lxqt-build-tools/pull/76
    (fetchpatch {
      name = "fix-pkg-config.patch";
      url = "https://github.com/lxqt/lxqt-build-tools/pull/76/commits/fa9672b671ede3f46b004f81580f9afb50fedf00.patch";
      sha256 = "0dl7n1afcc6ky9vd9lpc65p9grpszpql7lfjq2vlzlilixnv8xv1";
    })
    # Fix build failure of libqtxdg with GLib 2.73.1+
    # https://github.com/lxqt/lxqt-build-tools/pull/79
    (fetchpatch {
      url = "https://github.com/lxqt/lxqt-build-tools/commit/4991811d9212ec1176af6d1cbe88aa37efad4836.patch";
      sha256 = "sha256-PsYJKonMG6A9O4Li+RC1qBjFUzYgxVAwzSqHq/phmPc=";
    })
  ];

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
