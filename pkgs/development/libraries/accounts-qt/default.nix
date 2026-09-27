{
  stdenv,
  lib,
  fetchFromGitLab,
  testers,
  gitUpdater,
  dbus-test-runner,
  doxygen,
  glib,
  graphviz,
  libaccounts-glib,
  pkg-config,
  qmake,
  qtbase,
  qttools,
  writableTmpDirAsHomeHook,
}:

let
  withQt6 = lib.strings.versionAtLeast qtbase.version "6";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "accounts-qt";
  version = "1.17";

  src = fetchFromGitLab {
    owner = "accounts-sso";
    repo = "libaccounts-qt";
    tag = "VERSION_${finalAttrs.version}";
    hash = "sha256-mPZgD4r7vlUP6wklvZVknGqTXZBckSOtNzK7p6e2qSA=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  postPatch =
    # Don't install test binary. Not useful, and it has ref to /build.
    ''
      substituteInPlace tests/tst_libaccounts.pro \
        --replace-fail 'include( ../common-installs-config.pri )' '# include( ../common-installs-config.pri )'
    ''
    # Let Nix do the timeout.
    + ''
      substituteInPlace tests/accountstest.sh \
        --replace-fail 'dbus-test-runner -m 180' 'dbus-test-runner -m 0'
    ''
    # We're installing headers to dev output
    + ''
      substituteInPlace Accounts/AccountsQt*Config.cmake.in \
        --replace-fail 'set(ACCOUNTSQT_INCLUDE_DIRS $${INSTALL_PREFIX}' 'set(ACCOUNTSQT_INCLUDE_DIRS $${NIX_OUTPUT_DEV}'
    ''
    # qhelpgenerator isn't on PATH w/ Qt6
    + ''
      substituteInPlace doc/doxy.conf \
        --replace-fail \
          '= qhelpgenerator' \
          '= ${if withQt6 then "${qttools}/libexec" else "${lib.getDev qttools}/bin"}/qhelpgenerator'
    '';

  # QMake
  strictDeps = false;

  nativeBuildInputs = [
    doxygen
    graphviz
    pkg-config
    qmake
    writableTmpDirAsHomeHook # to stop doxygen from complaining
  ];

  propagatedBuildInputs = [
    glib
    libaccounts-glib
  ];

  nativeCheckInputs = [
    dbus-test-runner
  ];

  # Library
  dontWrapQtApps = true;

  # Configure *now*
  postConfigure = ''
    make qmake_all
  '';

  postBuild = ''
    make docs
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # For qhelpgenerator to find minimal plugin
  env.QT_PLUGIN_PATH = "${lib.getBin qtbase}/${qtbase.qtPluginPrefix}";

  passthru = {
    tests.pkg-config = testers.hasPkgConfigModules {
      package = finalAttrs.finalPackage;
      versionCheck = true;
    };
    updateScript = gitUpdater {
      rev-prefix = "VERSION_";
    };
  };

  meta = {
    description = "Qt-based client library for the accounts database";
    homepage = "https://accounts-sso.gitlab.io/";
    license = lib.licenses.lgpl21Only;
    maintainers = [ lib.maintainers.OPNA2608 ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "accounts-qt${lib.versions.major qtbase.version}"
    ];
  };
})
