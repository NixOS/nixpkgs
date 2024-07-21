{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, cmake
, cmake-extras
, dbus
, dbus-test-runner
, glib
, gtest
, intltool
, json-glib
, libapparmor
, libxkbcommon
, lomiri-app-launch
, lomiri-ui-toolkit
, makeWrapper
, pkg-config
, python3
, qtbase
, qtdeclarative
, qtwayland
, runtimeShell
, sqlite
, systemd
, wrapQtAppsHook
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
  ];

  patches = [
    # Fix case-sensitivity in tests
    # Remove when https://gitlab.com/ubports/development/core/lomiri-url-dispatcher/-/merge_requests/8 merged & in release
    (fetchpatch {
      url = "https://gitlab.com/sunweaver/lomiri-url-dispatcher/-/commit/ebdd31b9640ca243e90bc7b8aca7951085998bd8.patch";
      hash = "sha256-g4EohB3oDcWK4x62/3r/g6CFxqb7/rdK51+E/Fji1Do=";
    })
  ];

  postPatch = ''
    substituteInPlace data/CMakeLists.txt \
      --replace "\''${SYSTEMD_USER_UNIT_DIR}" "\''${CMAKE_INSTALL_LIBDIR}/systemd/user"

    substituteInPlace tests/url_dispatcher_testability/CMakeLists.txt \
      --replace "\''${PYTHON_PACKAGE_DIR}" "$out/${python3.sitePackages}"

    # Update URI handler database whenever new url-handler is installed system-wide
    substituteInPlace data/lomiri-url-dispatcher-update-system-dir.*.in \
      --replace '@CMAKE_INSTALL_FULL_DATAROOTDIR@' '/run/current-system/sw/share'
  '' + lib.optionalString finalAttrs.finalPackage.doCheck ''
    patchShebangs tests/test-sql.sh
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    glib # for gdbus-codegen
    intltool
    makeWrapper
    pkg-config
    (python3.withPackages (ps: with ps; [
      setuptools
    ] ++ lib.optionals finalAttrs.finalPackage.doCheck [
      python-dbusmock
    ]))
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
    "-DLOCAL_INSTALL=ON"
    "-Denable_mirclient=OFF"
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  # Tests work with an sqlite db, cannot handle >1 test at the same time
  enableParallelChecking = false;

  dontWrapQtApps = true;

  preFixup = ''
    substituteInPlace $out/bin/lomiri-url-dispatcher-dump \
      --replace '/bin/sh' '${runtimeShell}'

    wrapProgram $out/bin/lomiri-url-dispatcher-dump \
      --prefix PATH : ${lib.makeBinPath [ sqlite ]}

    # Move from qmlscene call in desktop file to easier-to-wrap script
    guiScript=$out/bin/lomiri-url-dispatcher-gui
    guiExec=$(grep 'Exec=' $out/share/applications/lomiri-url-dispatcher-gui.desktop | cut -d'=' -f2-)

    cat <<EOF >$guiScript
    #!${runtimeShell}
    $guiExec
    EOF
    chmod +x $guiScript

    mkdir -p $out/share/icons/hicolor/scalable/apps
    ln -s $out/share/lomiri-url-dispatcher/gui/lomiri-url-dispatcher-gui.svg $out/share/icons/hicolor/scalable/apps/

    substituteInPlace $out/share/applications/lomiri-url-dispatcher-gui.desktop \
      --replace "Exec=$guiExec" "Exec=$(basename $guiScript)" \
      --replace "Icon=$out/share/lomiri-url-dispatcher/gui/lomiri-url-dispatcher-gui.svg" "Icon=lomiri-url-dispatcher-gui"

    # Calls qmlscene from PATH, needs Qt plugins & QML components
    qtWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ qtdeclarative.dev ]}
    )
    wrapQtApp $guiScript
  '';

  passthru = {
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
    updateScript = gitUpdater { };
  };

  meta = with lib; {
    description = "Lomiri operating environment service for requesting URLs to be opened";
    longDescription = ''
       Allows applications to request a URL to be opened and handled by another
       process without seeing the list of other applications on the system or
       starting them inside its own Application Confinement.
    '';
    homepage = "https://gitlab.com/ubports/development/core/lomiri-url-dispatcher";
    license = with licenses; [ lgpl3Only gpl3Only ];
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
    pkgConfigModules = [
      "lomiri-url-dispatcher"
    ];
  };
})
