{
  lib,
  stdenv,

  fetchFromGitHub,

  python3,
  qmake,

  qt5compat ? null,
  qtbase,
  qtdeclarative,
  qtsvg,
  qttools,
  qtwebengine,
  qtxmlpatterns ? null,

  qt6Support ? false,
}:

let
  qtVersion = lib.getVersion qtbase;
  pyVersion = lib.getVersion python3;
  versions = "Qt${lib.versions.major qtVersion}-Python${lib.versions.majorMinor pyVersion}";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "python-qt";
  version = "3.6.1-unstable-2025-11-20";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    # tag = "v${finalAttrs.version}";
    rev = "fd97b4b2ca5fc94a3219b002aadfbe2e8c89f59d";
    hash = "sha256-BAuvs23VBKt6g5gpAtMUPyikL+D3sMEpch1BLICUotc=";
  };

  nativeBuildInputs = [
    qmake
  ];

  buildInputs = [
    python3
    qtdeclarative
    qtsvg
    qttools
  ]
  ++ lib.optionals qt6Support [
    qt5compat
    qtwebengine # optional and vulnerable in Qt5
  ]
  ++ lib.optionals (!qt6Support) [
    qtxmlpatterns
  ];

  env.QTDIR = "${qtbase}"; # Used to find qtcoreversion.h

  # generated cpp is available for many Qt5 versions but not Qt6
  # ref. https://github.com/MeVisLab/pythonqt#binding-generator
  preConfigure = lib.optionalString qt6Support (
    let
      includePaths = lib.concatMapStringsSep ":" (p: "${p}/include") [
        qtbase
        qtdeclarative
        qtsvg
        qttools
        qtwebengine
      ];
    in
    ''
      pushd generator
      qmake $qmakeFlags CONFIG+=Release generator.pro
      make -j $NIX_BUILD_CORES
      ./pythonqt_generator \
        --include-paths=${includePaths} \
        --qt-version=${qtVersion} \
        qtscript_masterinclude.h \
        build_all.txt
      popd
    ''
  );

  qmakeFlags = [
    "PYTHON_DIR=${python3}"
    "PYTHON_VERSION=${lib.versions.majorMinor pyVersion}"
  ];

  dontWrapQtApps = true;

  installPhase = ''
    mkdir -p $out/include/PythonQt
    cp -r ./lib $out
    cp -r ./src/* $out/include/PythonQt
    cp -r ./build $out/include/PythonQt
    cp -r ./extensions $out/include/PythonQt
  '';

  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin ''
    install_name_tool \
      -id $out/lib/libPythonQt-${versions}.dylib \
          $out/lib/libPythonQt-${versions}.dylib

    install_name_tool \
      -change      libPythonQt-${versions}.3.dylib \
          $out/lib/libPythonQt-${versions}.3.dylib \
      -id $out/lib/libPythonQt_QtAll-${versions}.dylib \
          $out/lib/libPythonQt_QtAll-${versions}.dylib
  '';

  meta = {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    homepage = "https://mevislab.github.io/pythonqt/";
    license = lib.licenses.lgpl21;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      hlolli
      nim65s
    ];
    # ref. https://github.com/MeVisLab/pythonqt/issues/276
    broken = stdenv.hostPlatform.isDarwin && qt6Support;
  };
})
