{ stdenv
, lib
, fetchFromGitLab
, gitUpdater
, cmake
, cmake-extras
, pkg-config
, python3
, qtbase
, qtdeclarative
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lomiri-settings-components";
  version = "1.1.1";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/lomiri-settings-components";
    rev = finalAttrs.version;
    hash = "sha256-2Wyh+2AW6EeKRv26D4l+GIoH5sWC9SmOODNHOveFZPg=";
  };

  postPatch = ''
    patchShebangs tests/imports/check_imports.py

    substituteInPlace CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" '${placeholder "out"}/${qtbase.qtQmlPrefix}'
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    sed -i CMakeLists.txt \
      -e '/add_subdirectory(tests)/d'
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    cmake-extras
    qtbase
    qtdeclarative
  ];

  nativeCheckInputs = [
    python3
  ];

  # No apps, just QML components
  dontWrapQtApps = true;

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "QML settings components for the Lomiri Desktop Environment";
    homepage = "https://gitlab.com/ubports/development/core/lomiri-settings-components";
    changelog = "https://gitlab.com/ubports/development/core/lomiri-settings-components/-/blob/${finalAttrs.version}/ChangeLog";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    platforms = platforms.linux;
  };
})
