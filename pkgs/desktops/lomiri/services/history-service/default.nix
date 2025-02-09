{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, dbus
, dbus-test-runner
, dconf
, gnome
, libphonenumber
, libqtdbustest
, pkg-config
, protobuf
, qtbase
, qtdeclarative
, qtpim
, sqlite
, telepathy
, telepathy-mission-control
, wrapQtAppsHook
, xvfb-run
}:

let
  replaceDbusService = pkg: name: "--replace \"\\\${DBUS_SERVICES_DIR}/${name}\" \"${pkg}/share/dbus-1/services/${name}\"";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "history-service";
  version = "0.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/history-service";
    rev = finalAttrs.version;
    hash = "sha256-oCX+moGQewzstbpddEYYp1kQdO2mVXpWJITfvzDzQDI=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # Deprecation warnings with Qt5.15, allow disabling -Werror
    # Remove when version > 0.4
    (fetchpatch {
      url = "https://gitlab.com/ubports/development/core/history-service/-/commit/1370777952c6a2efb85f582ff8ba085c2c0e290a.patch";
      hash = "sha256-Z/dFrFo7WoPZlKto6wNGeWdopsi8iBjmd5ycbqMKgxo=";
    })

    # Drop deprecated qt5_use_modules usage
    # Remove when https://gitlab.com/ubports/development/core/history-service/-/merge_requests/36 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/history-service/-/commit/b36ab377aca93555b29d1471d6eaa706b5c843ca.patch";
      hash = "sha256-mOpXqqd4JI7lHtcWDm9LGCrtB8ERge04jMpHIagDM2k=";
    })

    # Add more / correct existing GNUInstallDirs usage
    # Remove when https://gitlab.com/ubports/development/core/history-service/-/merge_requests/37 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/history-service/-/commit/bb4dbdd16e80dcd286d8edfb86b08f0b61bc7fec.patch";
      hash = "sha256-C/XaygI663yaU06klQD9g0NnbqYxHSmzdbrRxcfiJkk=";
    })

    # Correct version information
    # Remove when https://gitlab.com/ubports/development/core/history-service/-/merge_requests/38 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/history-service/-/commit/30d9fbee203205ec1ea8fd19c9b6eb54c080a9e2.patch";
      hash = "sha256-vSZ1ii5Yhw7pB+Pd1pjWnW7JsQxKnn+LeuBKo6qZjQs=";
    })

    # Make tests optional
    # Remove when https://gitlab.com/ubports/development/core/history-service/-/merge_requests/39 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/history-service/-/commit/cb5c80cffc35611657244e15a7eb10edcd598ccd.patch";
      hash = "sha256-MFHGu4OMScdThq9htUgFMpezP7Ym6YTIZUHWol20wqw=";
    })
  ];

  postPatch = ''
    # Upstream's way of generating their schema doesn't work for us, don't quite understand why.
    # (gdb) bt
    # #0  QSQLiteResult::prepare (this=0x4a4650, query=...) at qsql_sqlite.cpp:406
    # #1  0x00007ffff344bcf4 in QSQLiteResult::reset (this=0x4a4650, query=...) at qsql_sqlite.cpp:378
    # #2  0x00007ffff7f95f39 in QSqlQuery::exec (this=this@entry=0x7fffffffaad8, query=...) at kernel/qsqlquery.cpp:406
    # #3  0x00000000004084cb in SQLiteDatabase::dumpSchema (this=<optimized out>) at /build/source/plugins/sqlite/sqlitedatabase.cpp:148
    # #4  0x0000000000406d70 in main (argc=<optimized out>, argv=<optimized out>)
    #     at /build/source/plugins/sqlite/schema/generate_schema.cpp:56
    # (gdb) p lastError().driverText().toStdString()
    # $17 = {_M_dataplus = {<std::allocator<char>> = {<std::__new_allocator<char>> = {<No data fields>}, <No data fields>},
    #     _M_p = 0x4880d0 "Unable to execute statement"}, _M_string_length = 27, {
    #     _M_local_buf = "\033\000\000\000\000\000\000\000+\344\371\367\377\177\000", _M_allocated_capacity = 27}}
    # (gdb) p lastError().databaseText().toStdString()
    # $18 = {_M_dataplus = {<std::allocator<char>> = {<std::__new_allocator<char>> = {<No data fields>}, <No data fields>},
    #     _M_p = 0x48c480 "no such column: rowid"}, _M_string_length = 21, {
    #     _M_local_buf = "\025\000\000\000\000\000\000\000A\344\371\367\377\177\000", _M_allocated_capacity = 21}}
    #
    # This makes the tests stall indefinitely and breaks history-service usage.
    # This replacement script should hopefully achieve the same / a similar-enough result with just sqlite
    cp ${./update_schema.sh.in} plugins/sqlite/schema/update_schema.sh.in

    # libphonenumber -> protobuf -> abseil-cpp demands C++14
    # But uses std::string_view which is C++17?
    substituteInPlace CMakeLists.txt \
      --replace '-std=c++11' '-std=c++17'

    # Uses pkg_get_variable, cannot substitute prefix with that
    substituteInPlace daemon/CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_UNIT_DIR "''${CMAKE_INSTALL_PREFIX}/lib/systemd/user")'

    # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
    substituteInPlace CMakeLists.txt \
      --replace "\''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML" "echo $out/${qtbase.qtQmlPrefix}"
  '' + lib.optionalString finalAttrs.finalPackage.doCheck ''
    # Tests launch these DBus services, fix paths related to them
    substituteInPlace tests/common/dbus-services/CMakeLists.txt \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.MissionControl5.service"} \
      ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.AccountManager.service"} \
      ${replaceDbusService dconf "ca.desrt.dconf.service"}

    substituteInPlace cmake/modules/GenerateTest.cmake \
      --replace '/usr/lib/dconf' '${lib.getLib dconf}/libexec' \
      --replace '/usr/lib/telepathy' '${lib.getLib telepathy-mission-control}/libexec'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    sqlite
    wrapQtAppsHook
  ];

  buildInputs = [
    libphonenumber
    protobuf
    qtbase
    qtdeclarative
    qtpim
    telepathy
  ];

  nativeCheckInputs = [
    dbus
    dbus-test-runner
    dconf
    gnome.gnome-keyring
    telepathy-mission-control
    xvfb-run
  ];

  cmakeFlags = [
    # Many deprecation warnings with Qt 5.15
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (lib.concatStringsSep ";" [
      # DaemonTest is flaky
      # https://gitlab.com/ubports/development/core/history-service/-/issues/13
      "-E" "^DaemonTest"
    ]))
  ];

  preBuild = ''
    # SQLiteDatabase is used on host to generate SQL schemas
    # Tests also need this to use SQLiteDatabase for verifying correct behaviour
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Starts & talks to D-Bus services, breaks with parallelism
  enableParallelChecking = false;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtpim}/${qtbase.qtPluginPrefix}:$QT_PLUGIN_PATH
    export HOME=$PWD
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Service that provides call log and conversation history";
    longDescription = ''
      History service provides the database and an API to store/retrieve the call log (used by dialer-app) and the sms/mms history (used by messaging-app).

      See as well telepathy-ofono for incoming message events.

      Database location: ~/.local/share/history-service/history.sqlite
    '';
    homepage = "https://gitlab.com/ubports/development/core/history-service";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "history-service"
    ];
  };
})
