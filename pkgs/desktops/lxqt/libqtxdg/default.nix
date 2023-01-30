{ lib
, mkDerivation
, fetchFromGitHub
, cmake
, qtbase
, qtsvg
, lxqt-build-tools
, gitUpdater
}:

mkDerivation rec {
  pname = "libqtxdg";
  version = "3.10.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "Lynm6Qxy02Os69YQ1cb2W0hV7sq9kBhbACqjHTGj7Tw=";
  };

  nativeBuildInputs = [
    cmake
    lxqt-build-tools
  ];

  buildInputs = [
    qtbase
    qtsvg
  ];

  preConfigure = ''
    cmakeFlagsArray+=(
      "-DQTXDGX_ICONENGINEPLUGIN_INSTALL_PATH=$out/$qtPluginPrefix/iconengines"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
      "-DCMAKE_INSTALL_LIBDIR=lib"
    )
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    homepage = "https://github.com/lxqt/libqtxdg";
    description = "Qt implementation of freedesktop.org xdg specs";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
    maintainers = teams.lxqt.members;
  };
}
