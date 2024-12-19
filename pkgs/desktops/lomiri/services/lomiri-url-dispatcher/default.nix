{
  stdenv,
  lib,
  fetchFromGitLab,
  fetchpatch,
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
  version = "0.1.3";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-url-dispatcher";
    rev = finalAttrs.version;
    hash = "sha256-kde/HzhBHxTeyc2TCUJwpG7IfC8doDd/jNMF8KLM7KU=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
  ];

  patches = [
    # Fix case-sensitivity in tests
    # Remove when https://gitlab.com/ubports/development/core/lomiri-url-dispatcher/-/merge_requests/8 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/sunweaver/lomiri-url-dispatcher/-/commit/ebdd31b9640ca243e90bc7b8aca7951085998bd8.patch";
      hash = "sha256-g4EohB3oDcWK4x62/3r/g6CFxqb7/rdK51+E/Fji1Do=";
    })

    # Make lomiri-url-dispatcher-gui wrappable
    # Remove when https://gitlab.com/ubports/development/core/lomiri-url-dispatcher/-/merge_requests/28 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/ubports/development/core/lomiri-url-dispatcher/-/commit/6512937e2b388ad1350072b8ed3b4140439b2321.patch";
      hash = "sha256-P1A3hi8l7fJWFjGeK5hWYl8BoZMzRfo44MUTeM7vG2A=";
    })
  ];

  postPatch =
    ''
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
    license = with lib.licenses; [
      lgpl3Only
      gpl3Only
    ];
    maintainers = lib.teams.lomiri.members;
    platforms = lib.platforms.linux;
    pkgConfigModules = [
      "lomiri-url-dispatcher"
    ];
  };
})
