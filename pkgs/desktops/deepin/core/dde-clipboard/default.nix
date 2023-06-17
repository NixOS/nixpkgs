{ stdenv
, lib
, fetchFromGitHub
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
, gio-qt
, cmake
, qttools
, kwayland
, pkg-config
, wrapQtAppsHook
, glibmm
, gtest
}:

stdenv.mkDerivation rec {
  pname = "dde-clipboard";
  version = "5.4.25";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    sha256 = "sha256-oFATOBXf4NvGxjVMlfxwfQkBffeKut8ao+X6T9twb/I=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "/etc/xdg" "$out/etc/xdg" \
      --replace "/lib/systemd/user" "$out/lib/systemd/user" \
      --replace "/usr/share" "$out/share"

    substituteInPlace misc/com.deepin.dde.Clipboard.service \
      --replace "/usr/bin/qdbus" "${lib.getBin qttools}/bin/qdbus"

    substituteInPlace misc/{dde-clipboard.desktop,dde-clipboard-daemon.service,com.deepin.dde.Clipboard.service} \
      --replace "/usr" "$out"

    patchShebangs translate_generation.sh generate_gtest_report.sh
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    qttools
    wrapQtAppsHook
  ];

  buildInputs = [
    dtkwidget
    qt5integration
    qt5platform-plugins
    dde-qt-dbus-factory
    gio-qt
    kwayland
    glibmm
    gtest
  ];

  cmakeFlags = [
    "-DUSE_DEEPIN_WAYLAND=OFF"
  ];

  meta = with lib; {
    description = "DDE optional clipboard manager componment";
    homepage = "https://github.com/linuxdeepin/dde-clipboard";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
