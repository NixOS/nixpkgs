{ stdenv
, lib
, fetchFromGitLab
, fetchpatch
, gitUpdater
, testers
, boost
, cmake
, cmake-extras
, dbus
, dbus-cpp
, gtest
, libapparmor
, libelf
, pkg-config
, process-cpp
, properties-cpp
, qtbase
, qtdeclarative
, sqlite
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biometryd";
  version = "0.3.0";

  src = fetchFromGitLab {
    owner = "ubports";
    repo = "development/core/biometryd";
    rev = finalAttrs.version;
    hash = "sha256-b095rsQnd63Ziqe+rn3ROo4LGXZxZ3Sa6h3apzCuyCs=";
  };

  outputs = [
    "out"
    "dev"
  ];

  patches = [
    # https://gitlab.com/ubports/development/core/biometryd/-/merge_requests/31
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/biometryd/-/commit/d01d979e4f98c6473761d1ace308aa182017804e.patch";
      hash = "sha256-JxL3BLuh33ptfneU1y2qNGFKpeMlZlTMwCK97Rk3aTA=";
    })
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/biometryd/-/commit/3cec6a3d42ea6aba8892da2c771b317f44daf9e2.patch";
      hash = "sha256-Ij/aio38WmZ+NsUSbM195Gwb83goWIcCnJvGwAOJi50=";
    })
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/biometryd/-/commit/e89bd9444bc1cfe84a9aa93faa23057c80f39564.patch";
      hash = "sha256-1vEG349X9+SvY/f3no/l5cMVGpdzC8h/8XOZwL/70Dc=";
    })

    # https://gitlab.com/ubports/development/core/biometryd/-/merge_requests/32
    (fetchpatch {
      url = "https://gitlab.com/OPNA2608/biometryd/-/commit/9e52fad0139c5a45f69e6a6256b2b5ff54f77740.patch";
      hash = "sha256-DZSdzKq6EYgAllKSDgkGk2g57zHN+gI5fOoj7U5AcKY=";
    })
  ];

  postPatch = ''
    # Remove with !31 patches, fetchpatch can't apply renames
    pushd data
    for type in conf service; do
      mv biometryd.$type biometryd.$type.in
      substituteInPlace biometryd.$type.in \
        --replace '/usr/bin' "\''${CMAKE_INSTALL_FULL_BINDIR}"
    done
    popd

    # Uses pkg_get_variable, cannot substitute prefix with that
    substituteInPlace CMakeLists.txt \
      --replace 'pkg_get_variable(SYSTEMD_SYSTEM_UNIT_DIR systemd systemdsystemunitdir)' 'set(SYSTEMD_SYSTEM_UNIT_DIR "${placeholder "out"}/lib/systemd/system")'

    substituteInPlace src/biometry/qml/Biometryd/CMakeLists.txt \
      --replace "\''${CMAKE_INSTALL_LIBDIR}/qt5/qml" "\''${CMAKE_INSTALL_PREFIX}/${qtbase.qtQmlPrefix}"
  '' + lib.optionalString (!finalAttrs.doCheck) ''
    sed -i -e '/add_subdirectory(tests)/d' CMakeLists.txt
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qtdeclarative # qmlplugindump
  ];

  buildInputs = [
    boost
    cmake-extras
    dbus
    dbus-cpp
    libapparmor
    libelf
    process-cpp
    properties-cpp
    qtbase
    qtdeclarative
    sqlite
  ];

  checkInputs = [
    gtest
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DENABLE_WERROR=OFF"
    "-DWITH_HYBRIS=OFF"
  ];

  preBuild = ''
    # Generating plugins.qmltypes (also used in checkPhase?)
    export QT_PLUGIN_PATH=${lib.getBin qtbase}/${qtbase.qtPluginPrefix}
  '';

  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  meta = with lib; {
    description = "Mediates/multiplexes access to biometric devices";
    longDescription = ''
      biometryd mediates and multiplexes access to biometric devices present
      on the system, enabling applications and system components to leverage
      them for identification and verification of users.
    '';
    homepage = "https://gitlab.com/ubports/development/core/biometryd";
    license = licenses.lgpl3Only;
    maintainers = teams.lomiri.members;
    mainProgram = "biometryd";
    platforms = platforms.linux;
    pkgConfigModules = [
      "biometryd"
    ];
  };
})
