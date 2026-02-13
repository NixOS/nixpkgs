{
  lib,
  stdenv,
  fetchFromGitHub,
  kdePackages,
  cpp-utilities,
  boost,
  cmake,
  iconv,
  cppunit,
  syncthing,
  xdg-utils,
  webviewSupport ? true,
  jsSupport ? true,
  kioPluginSupport ? stdenv.hostPlatform.isLinux,
  plasmoidSupport ? stdenv.hostPlatform.isLinux,
  systemdSupport ? stdenv.hostPlatform.isLinux,
  /*
    It is possible to set via this option an absolute exec path that will be
    written to the `~/.config/autostart/syncthingtray.desktop` file generated
    during runtime. Alternatively, one can edit the desktop file themselves after
    it is generated See:
    https://github.com/NixOS/nixpkgs/issues/199596#issuecomment-1310136382
  */
  autostartExecPath ? "syncthingtray",
  versionCheckHook,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.0.7";
  pname = "syncthingtray";

  src = fetchFromGitHub {
    owner = "Martchus";
    repo = "syncthingtray";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aY2uKYmTC/eDv/ioenI5JrS6/kaod5ntxgGHvoszNFU=";
  };

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtsvg
    cpp-utilities
    kdePackages.qtutilities
    boost
    kdePackages.qtforkawesome
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ iconv ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ kdePackages.qtwayland ]
  ++ lib.optionals webviewSupport [ kdePackages.qtwebengine ]
  ++ lib.optionals jsSupport [ kdePackages.qtdeclarative ]
  ++ lib.optionals kioPluginSupport [ kdePackages.kio ]
  ++ lib.optionals plasmoidSupport [ kdePackages.libplasma ];

  nativeBuildInputs = [
    kdePackages.wrapQtAppsHook
    cmake
    kdePackages.qttools
    # Although these are test dependencies, we add them anyway so that we test
    # whether the test units compile. On Darwin we don't run the tests but we
    # still build them.
    cppunit
    syncthing
  ]
  ++ lib.optionals plasmoidSupport [ kdePackages.extra-cmake-modules ];

  # syncthing server seems to hang on darwin, causing tests to fail.
  doCheck = !stdenv.hostPlatform.isDarwin;
  preCheck = ''
    export QT_QPA_PLATFORM=offscreen
    export QT_PLUGIN_PATH="${lib.getBin kdePackages.qtbase}/${kdePackages.qtbase.qtPluginPrefix}"
  '';
  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    # put the app bundle into the proper place /Applications instead of /bin
    mkdir -p $out/Applications
    mv $out/bin/syncthingtray.app $out/Applications
    # Make binary available in PATH like on other platforms
    ln -s $out/Applications/syncthingtray.app/Contents/MacOS/syncthingtray $out/bin/syncthingtray
  '';
  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  cmakeFlags = [
    "-DQT_PACKAGE_PREFIX=Qt${lib.versions.major kdePackages.qtbase.version}"
    "-DKF_PACKAGE_PREFIX=KF${lib.versions.major kdePackages.qtbase.version}"
    "-DBUILD_TESTING=ON"
    # See https://github.com/Martchus/syncthingtray/issues/208
    "-DEXCLUDE_TESTS_FROM_ALL=OFF"
    "-DAUTOSTART_EXEC_PATH=${autostartExecPath}"
    # See https://github.com/Martchus/syncthingtray/issues/42
    "-DQT_PLUGIN_DIR:STRING=${placeholder "out"}/${kdePackages.qtbase.qtPluginPrefix}"
    "-DBUILD_SHARED_LIBS=ON"
  ]
  ++ lib.optionals (!plasmoidSupport) [ "-DNO_PLASMOID=ON" ]
  ++ lib.optionals (!kioPluginSupport) [ "-DNO_FILE_ITEM_ACTION_PLUGIN=ON" ]
  ++ lib.optionals systemdSupport [ "-DSYSTEMD_SUPPORT=ON" ]
  ++ lib.optionals (!webviewSupport) [ "-DWEBVIEW_PROVIDER:STRING=none" ];

  qtWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ xdg-utils ]}"
  ];

  meta = {
    homepage = "https://github.com/Martchus/syncthingtray";
    description = "Tray application and Dolphin/Plasma integration for Syncthing";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ doronbehar ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "syncthingtray";
  };
})
