{ stdenv
, lib
, fetchFromGitLab
, biometryd
, cmake
, libqtdbusmock
, libqtdbustest
, lomiri-system-settings-unwrapped
, pkg-config
, polkit
, python3
, qtbase
, qtdeclarative
, trust-store
, xvfb-run
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-system-settings-security-privacy";
  version = "1.0.2";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-system-settings-security-privacy";
    rev = finalAttrs.version;
    hash = "sha256-d7OgxV362gJ3t5N+DEFgwyK+m6Ij6juRPuxfmbCg68Y=";
  };

  postPatch = ''
    # CMake pkg_get_variable cannot replace prefix variable yet
    for pcvar in plugin_manifest_dir plugin_private_module_dir plugin_qml_dir; do
      pcvarname=$(echo $pcvar | tr '[:lower:]' '[:upper:]')
      substituteInPlace CMakeLists.txt \
        --replace-fail "pkg_get_variable($pcvarname LomiriSystemSettings $pcvar)" "set($pcvarname $(pkg-config LomiriSystemSettings --define-variable=prefix=$out --define-variable=libdir=$out/lib --variable=$pcvar))"
    done
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    lomiri-system-settings-unwrapped
    polkit
    qtbase
    qtdeclarative
    trust-store
  ];

  # QML components and schemas the wrapper needs
  propagatedBuildInputs = [
    biometryd
  ];

  nativeCheckInputs = [
    xvfb-run
  ];

  checkInputs = [
    libqtdbusmock
    libqtdbustest
  ];

  # Plugin library & modules for LSS
  dontWrapQtApps = true;

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  preCheck = ''
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  meta = with lib; {
    description = "Security and privacy settings plugin for Lomiri system settings";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-system-settings-security-privacy";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-system-settings-security-privacy/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.gpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
