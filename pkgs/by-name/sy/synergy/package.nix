{
  withGUI ? true,
  stdenv,
  lib,
  fetchFromGitHub,

  cmake,
  openssl,
  pcre,
  util-linux,
  libselinux,
  libsepol,
  pkg-config,
  gdk-pixbuf,
  libnotify,
  libICE,
  libSM,
  libX11,
  libxkbfile,
  libXi,
  libXtst,
  libXrandr,
  libXinerama,
  xkeyboardconfig,
  gtest,
  lerc,
  libdeflate,
  libsysprof-capture,
  libwebp,
  libxcb-cursor,
  python3,
  qt6,
  tomlplusplus,
  xinput,
  avahi-compat,
  cli11,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "synergy";
  version = "1.20.0";

  src = fetchFromGitHub {
    owner = "symless";
    repo = "synergy-core";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cY+npgBkDOPAe6IUGvJMGiVDr8ZRHmj2BEXvPOmYZY0=";
    fetchSubmodules = false;
  };

  postUnpack =
    let
      synergyExtraSubmodule = fetchFromGitHub {
        owner = "symless";
        repo = "synergy-extra";
        rev = "5056ed0d4a22e00a4c410733cc0129040de84099";
        hash = "sha256-137ozE5xexzkdl++wiqZxkTy0b8NfhooKF5vpQdDNRw=";
      };

    in
    ''
      # Synergy pulls in `synergy-extra` via an *SSH* url since march 2025
      # This breaks the submodule fetching functionality of `fetchFromGitHub`
      rmdir $sourceRoot/ext/synergy-extra
      mkdir -p $sourceRoot/ext
      cp -r ${synergyExtraSubmodule} $sourceRoot/ext/synergy-extra
      chmod -R +w $sourceRoot/ext/synergy-extra
    '';

  postPatch = ''
    substituteInPlace cmake/Version.cmake --replace-fail \
      'version_from_git_tags(VERSION VERSION_MAJOR VERSION_MINOR VERSION_PATCH VERSION_REVISION)' \
      'set(VERSION "${finalAttrs.version}")'

    substituteInPlace cmake/Version.cmake --replace-fail \
      'set(DESKFLOW_VERSION_FOUR_PART "''${VERSION_MAJOR}.''${VERSION_MINOR}.''${VERSION_PATCH}.''${VERSION_REVISION}")' \
      'set(DESKFLOW_VERSION_FOUR_PART "${finalAttrs.version}.0")'

    substituteInPlace src/lib/gui/tls/TlsCertificate.cpp \
      --replace-fail 'kUnixOpenSslCommand = "openssl";' 'kUnixOpenSslCommand = "${openssl}/bin/openssl";'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/lib/deskflow/unix/AppUtilUnix.cpp \
      --replace-fail "/usr/share/X11/xkb/rules/evdev.xml" "${xkeyboardconfig}/share/X11/xkb/rules/evdev.xml"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ]
  ++ lib.optional withGUI qt6.wrapQtAppsHook;

  buildInputs = [
    qt6.qttools # Used for translations even when not building the GUI
    libsysprof-capture
    openssl
    pcre
    cli11
    tomlplusplus
    libdeflate
    lerc
    xz
    libwebp
    gtest
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    util-linux
    libselinux
    libsepol
    libICE
    libSM
    libX11
    libXi
    libXtst
    libXrandr
    libXinerama
    libxkbfile
    xinput
    avahi-compat
    gdk-pixbuf
    libnotify
    libxcb-cursor
  ];

  # Silences many warnings
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-inconsistent-missing-override";

  cmakeFlags =
    lib.optional (!withGUI) "-DSYNERGY_BUILD_LEGACY_GUI=OFF"
    # NSFilenamesPboardType is deprecated in 10.14+
    ++ lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_OSX_DEPLOYMENT_TARGET=${
      if stdenv.hostPlatform.isAarch64 then "10.13" else stdenv.hostPlatform.darwinSdkVersion
    }";

  doCheck = true;

  checkPhase = ''
    export QT_QPA_PLATFORM=offscreen
    runHook preCheck
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # filter out tests failing with sandboxing on darwin
    export GTEST_FILTER=-ServerConfigTests.serverconfig_will_deem_equal_configs_with_same_cell_names:NetworkAddress.hostname_valid_parsing
  ''
  + ''
    bin/unittests
    runHook postCheck
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/{synergy,synergy-server,synergy-client,synergy-legacy} $out/bin/
  ''
  + lib.optionalString withGUI ''
    cp bin/synergy $out/bin/
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/{applications,icons/hicolor/scalable/apps}
    cp ../res/app.svg $out/share/icons/hicolor/scalable/apps/synergy.svg
    substitute ../res/dist/linux/com.symless.synergy.desktop $out/share/applications/synergy.desktop \
      --replace "/usr/bin" "$out/bin"
  ''
  + lib.optionalString (stdenv.hostPlatform.isDarwin && withGUI) ''
    mkdir -p $out/Applications
    cp -r bundle/Synergy.app $out/Applications
    ln -s $out/bin $out/Applications/Synergy.app/Contents/MacOS
  ''
  + ''
    runHook postInstall
  '';

  dontWrapQtApps = lib.optional (!withGUI) true;

  meta = {
    description = "Share one mouse and keyboard between multiple computers";
    homepage = "https://symless.com/synergy";
    changelog = "https://github.com/symless/synergy/releases";
    mainProgram = lib.optionalString (!withGUI) "synergy-client";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ talyz ];
    platforms = lib.platforms.unix;
  };
})
