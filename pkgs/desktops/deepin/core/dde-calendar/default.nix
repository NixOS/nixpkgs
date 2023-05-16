{ stdenv
, lib
, fetchFromGitHub
<<<<<<< HEAD
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
=======
, fetchpatch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, dtkwidget
, qt5integration
, qt5platform-plugins
, dde-qt-dbus-factory
<<<<<<< HEAD
, qtbase
, qtsvg
, libical
, sqlite
, runtimeShell
=======
, cmake
, qttools
, pkg-config
, wrapQtAppsHook
, runtimeShell
, qtbase
, gtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

stdenv.mkDerivation rec {
  pname = "dde-calendar";
<<<<<<< HEAD
  version = "5.10.1";
=======
  version = "5.8.30";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    hash = "sha256-oPrtPOCLZof4BysWfsCYeoqbJf30r7LijGEEXZlsAAY=";
  };

  patches = [
    ./fix-wrapped-name-not-in-whitelist.diff
  ];

  postPatch = ''
    for file in $(grep -rl "/bin/bash"); do
      substituteInPlace $file --replace "/bin/bash" "${runtimeShell}"
    done
=======
    sha256 = "sha256-8/UXq9W3Gb1Lg/nOji6zcHJts6lgY2uDxvrBxQs3Zio=";
  };

  patches = [
    (fetchpatch {
      name = "chore-use-GNUInstallDirs-in-CmakeLists.patch";
      url = "https://github.com/linuxdeepin/dde-calendar/commit/b9d9555d90a36318eeee62ece49250b4bf8acd10.patch";
      sha256 = "sha256-pvgxZPczs/lkwNjysNuVu+1AY69VZlxOn7hR9A02/3M=";
    })
  ];

  postPatch = ''
    substituteInPlace calendar-service/src/dbmanager/huanglidatabase.cpp \
      --replace "/usr/share/dde-calendar/data/huangli.db" "$out/share/dde-calendar/data/huangli.db"
    substituteInPlace calendar-service/src/main.cpp \
      --replace "/usr/share/dde-calendar/translations" "$out/share/dde-calendar/translations"
    substituteInPlace calendar-service/assets/data/com.deepin.dataserver.Calendar.service \
      --replace "/usr/lib/deepin-daemon/dde-calendar-service" "$out/lib/deepin-daemon/dde-calendar-service"
    substituteInPlace calendar-client/assets/dbus/com.deepin.Calendar.service \
      --replace "/usr/bin/dde-calendar" "$out/bin/dde-calendar"
    substituteInPlace calendar-service/{src/{csystemdtimercontrol.cpp,jobremindmanager.cpp},assets/{data/com.dde.calendarserver.calendar.service,dde-calendar-service.desktop}} \
      --replace "/bin/bash" "${runtimeShell}"

    substituteInPlace CMakeLists.txt \
      --replace "ADD_SUBDIRECTORY(tests)" " "
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  nativeBuildInputs = [
    cmake
    qttools
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
<<<<<<< HEAD
    qt5integration
    qt5platform-plugins
    dtkwidget
    qtbase
    qtsvg
    dde-qt-dbus-factory
    libical
    sqlite
=======
    dtkwidget
    qt5platform-plugins
    dde-qt-dbus-factory
    gtest
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  cmakeFlags = [ "-DVERSION=${version}" ];

<<<<<<< HEAD
  strictDeps = true;
=======
  # qt5integration must be placed before qtsvg in QT_PLUGIN_PATH
  qtWrapperArgs = [
    "--prefix QT_PLUGIN_PATH : ${qt5integration}/${qtbase.qtPluginPrefix}"
  ];

  postFixup = ''
    wrapQtApp $out/lib/deepin-daemon/dde-calendar-service
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Calendar for Deepin Desktop Environment";
    homepage = "https://github.com/linuxdeepin/dde-calendar";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = teams.deepin.members;
  };
}
<<<<<<< HEAD

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
