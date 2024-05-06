{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  dbus,
  dbus-test-runner,
  dconf,
  gnome-keyring,
  libphonenumber,
  libqtdbustest,
  pkg-config,
  protobuf,
  qtbase,
  qtdeclarative,
  qtpim,
  sqlite,
  telepathy,
  telepathy-mission-control,
  validatePkgConfig,
  wrapQtAppsHook,
  xvfb-run,
}:

let
  replaceDbusService =
    pkg: name:
    "--replace-fail \"\\\${DBUS_SERVICES_DIR}/${name}\" \"${pkg}/share/dbus-1/services/${name}\"";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-history-service";
  version = "0.6";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/history-service";
    rev = finalAttrs.version;
    hash = "sha256-pcTYuumywTarW+ZciwwvmmBQQH6aq4+FdVjV62VzSZU=";
  };

  outputs = [
    "out"
    "dev"
  ];

  postPatch =
    ''
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

      # Uses pkg_get_variable, cannot substitute prefix with that
      substituteInPlace daemon/CMakeLists.txt \
        --replace-fail 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'set(SYSTEMD_USER_UNIT_DIR "''${CMAKE_INSTALL_PREFIX}/lib/systemd/user")'

      # Queries qmake for the QML installation path, which returns a reference to Qt5's build directory
      substituteInPlace CMakeLists.txt \
        --replace-fail "\''${QMAKE_EXECUTABLE} -query QT_INSTALL_QML" "echo $out/${qtbase.qtQmlPrefix}"
    ''
    + lib.optionalString finalAttrs.finalPackage.doCheck ''
      # Tests launch these DBus services, fix paths related to them
      substituteInPlace tests/common/dbus-services/CMakeLists.txt \
        ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.MissionControl5.service"} \
        ${replaceDbusService telepathy-mission-control "org.freedesktop.Telepathy.AccountManager.service"} \
        ${replaceDbusService dconf "ca.desrt.dconf.service"}

      substituteInPlace cmake/modules/GenerateTest.cmake \
        --replace-fail '/usr/lib/dconf' '${lib.getLib dconf}/libexec' \
        --replace-fail '/usr/lib/telepathy' '${lib.getLib telepathy-mission-control}/libexec'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    sqlite
    validatePkgConfig
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
    gnome-keyring
    telepathy-mission-control
    xvfb-run
  ];

  cmakeFlags = [
    # Many deprecation warnings with Qt 5.15
    (lib.cmakeBool "ENABLE_WERROR" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" (
      lib.concatStringsSep ";" [
        # DaemonTest is flaky
        # https://gitlab.com/ubports/development/core/history-service/-/issues/13
        "-E"
        "^DaemonTest"
      ]
    ))
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

  meta = {
    description = "Service that provides call log and conversation history";
    longDescription = ''
      History service provides the database and an API to store/retrieve the call log (used by dialer-app) and the sms/mms history (used by messaging-app).

      See as well telepathy-ofono for incoming message events.

      Database location: ~/.local/share/history-service/history.sqlite
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-history-service";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-history-service/-/blob/${finalAttrs.version}/ChangeLog";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [ "lomiri-history-service" ];
  };
})
