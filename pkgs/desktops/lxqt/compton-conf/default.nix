{ stdenv
, lib
, mkDerivation
, fetchFromGitHub
, cmake
, pkg-config
, qtbase
, qttools
, lxqt
, libconfig
, gitUpdater
}:

mkDerivation rec {
  pname = "compton-conf";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    hash = "sha256-GNS0GdkQOEFQHCeXFVNDdT35KCRhfwmkL78tpY71mz0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    lxqt.lxqt-build-tools
    qttools
  ];

  buildInputs = [
    qtbase
    libconfig
  ];

  preConfigure = ''
    substituteInPlace autostart/CMakeLists.txt \
      --replace "DESTINATION \"\''${LXQT_ETC_XDG_DIR}" "DESTINATION \"etc/xdg" \
  '';

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://github.com/lxqt/compton-conf";
    description = "GUI configuration tool for compton X composite manager";
    license = licenses.lgpl21Plus;
    platforms = with platforms; unix;
    maintainers = teams.lxqt.members;
  };
}
