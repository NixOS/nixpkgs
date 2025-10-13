{
  stdenv,
  lib,
  fetchFromGitLab,
  gitUpdater,
  testers,
  cmake,
  cmake-extras,
  dbus,
  dbus-test-runner,
  glib,
  gtest,
  intltool,
  json-glib,
  libapparmor,
  libxkbcommon,
  lomiri-app-launch,
  lomiri-ui-toolkit,
  makeWrapper,
  pkg-config,
  python3,
  qtbase,
  qtdeclarative,
  qtwayland,
  runtimeShell,
  sqlite,
  systemd,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-url-dispatcher";
  version = "0.1.4";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-url-dispatcher";
    tag = finalAttrs.version;
    hash = "sha256-+3/C6z8wyiNSpt/eyMl+j/TGJW0gZ5T3Vd1NmghK67k=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir)' 'pkg_get_variable(SYSTEMD_USER_UNIT_DIR systemd systemduserunitdir DEFINE_VARIABLES prefix=''${CMAKE_INSTALL_PREFIX})' \

    substituteInPlace gui/lomiri-url-dispatcher-gui.desktop.in.in \
      --replace-fail '@CMAKE_INSTALL_FULL_DATADIR@/lomiri-url-dispatcher/gui/lomiri-url-dispatcher-gui.svg' 'lomiri-url-dispatcher-gui'

    substituteInPlace tests/url_dispatcher_testability/CMakeLists.txt \
      --replace-fail "\''${PYTHON_PACKAGE_DIR}" "$out/${python3.sitePackages}"

    # Update URI handler database whenever new url-handler is installed system-wide
    substituteInPlace data/lomiri-url-dispatcher-update-system-dir.*.in \
      --replace-fail '@CMAKE_INSTALL_FULL_DATAROOTDIR@' '/run/current-system/sw/share'
  ''
  + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/test-sql.sh
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # for gdbus-codegen
    intltool
    makeWrapper
    pkg-config
    (python3.withPackages (
      ps:
      with ps;
      [
        setuptools
      ]
      ++ lib.optionals finalAttrs.finalPackage.doCheck [
        python-dbusmock
      ]
    ))
    wrapQtAppsHook
  ];

  buildInputs = [
    cmake-extras
    dbus-test-runner
    glib
    gtest
    json-glib
    libapparmor
    lomiri-app-launch
    lomiri-ui-toolkit
    qtdeclarative
    sqlite
    systemd
    libxkbcommon
  ];

  nativeCheckInputs = [
    dbus
    sqlite
  ];

  cmakeFlags = [
    (lib.cmakeBool "LOCAL_INSTALL" true)
    (lib.cmakeBool "enable_mirclient" false)
    # libexec has binaries that services will run
    # To reduce size for non-Lomiri situations that pull this package in (i.e. ayatana indicators)
    # we want only the solib in lib output
    # But service files have LIBEXECDIR path hardcoded, which would need manual fixing if using moveToOutput in fixup
    # Just tell it to put libexec stuff into other output
    (lib.cmakeFeature "CMAKE_INSTALL_LIBEXECDIR" "${placeholder "out"}/libexec")
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Tests work with an sqlite db, cannot handle >1 test at the same time
  enableParallelChecking = false;

  dontWrapQtApps = true;

  preFixup = ''
    substituteInPlace $out/bin/lomiri-url-dispatcher-{dump,gui} \
      --replace-fail '/bin/sh' '${runtimeShell}'

    wrapProgram $out/bin/lomiri-url-dispatcher-dump \
      --prefix PATH : ${lib.makeBinPath [ sqlite ]}

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/share/lomiri-url-dispatcher/gui/lomiri-url-dispatcher-gui.svg $out/share/icons/hicolor/scalable/apps/

    # Calls qmlscene from PATH, needs Qt plugins & QML components
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ qtdeclarative.dev ]}
    )
    wrapQtApp $out/bin/lomiri-url-dispatcher-gui
  '';

  postFixup = ''
    moveToOutput share $out
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = {
    description = "Lomiri operating environment service for requesting URLs to be opened";
    longDescription = ''
      Allows applications to request a URL to be opened and handled by another
      process without seeing the list of other applications on the system or
      starting them inside its own Application Confinement.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-url-dispatcher";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-url-dispatcher/-/blob/${
      if (!builtins.isNull finalAttrs.src.tag) then finalAttrs.src.tag else finalAttrs.src.rev
    }/ChangeLog";
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    teams = [ lib.teams.lomiri ];
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-url-dispatcher"
    ];
  };
})
