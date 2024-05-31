{
  lib,
  stdenv,
  cmake,
  ninja,
  python,
  moveBuildTree,
  shiboken6,
}:

stdenv.mkDerivation rec {
  pname = "pyside6";

  inherit (shiboken6) version src;

  patches = [
    # stripped down version of https://github.com/pyside/pyside-setup/commit/a0d68856d67ce6e178e3cfc2fccc236707e02fcd
    # FIXME: remove in next release
    ./qt-6.7.1.patch
  ];

  sourceRoot = "pyside-setup-everywhere-src-${version}/sources/${pname}";

  # FIXME: cmake/Macros/PySideModules.cmake supposes that all Qt frameworks on macOS
  # reside in the same directory as QtCore.framework, which is not true for Nix.
  postPatch = lib.optionalString stdenv.isLinux ''
    # Don't ignore optional Qt modules
    substituteInPlace cmake/PySideHelpers.cmake \
      --replace-fail \
        'string(FIND "''${_module_dir}" "''${_core_abs_dir}" found_basepath)' \
        'set (found_basepath 0)'
  '';

  nativeBuildInputs = [
    cmake
    ninja
    python
  ] ++ lib.optionals stdenv.isDarwin [ moveBuildTree ];

  buildInputs =
    with python.pkgs.qt6;
    [
      # required
      qtbase
      python.pkgs.ninja
      python.pkgs.packaging
      python.pkgs.setuptools
    ]
    ++ lib.optionals stdenv.isLinux [
      # optional
      qt3d
      qtcharts
      qtconnectivity
      qtdatavis3d
      qtdeclarative
      qthttpserver
      qtmultimedia
      qtnetworkauth
      qtquick3d
      qtremoteobjects
      qtscxml
      qtsensors
      qtspeech
      qtsvg
      qttools
      qtwebchannel
      qtwebengine
      qtwebsockets
    ];

  propagatedBuildInputs = [ shiboken6 ];

  cmakeFlags = [ "-DBUILD_TESTS=OFF" ];

  dontWrapQtApps = true;

  postInstall = ''
    cd ../../..
    ${python.pythonOnBuildForHost.interpreter} setup.py egg_info --build-type=pyside6
    cp -r PySide6.egg-info $out/${python.sitePackages}/
  '';

  meta = with lib; {
    description = "Python bindings for Qt";
    license = with licenses; [
      lgpl3Only
      gpl2Only
      gpl3Only
    ];
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [
      gebner
      Enzime
    ];
    platforms = platforms.all;
  };
}
