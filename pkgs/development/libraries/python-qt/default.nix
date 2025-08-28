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
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-OYFQtDGq+d32RQ0vChRKH//O9QgQPLMd1he8X3zCi+U=";
  };

  nativeBuildInputs = [
    qmake
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

  buildInputs = [ python3 ];

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

  meta = with lib; {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    homepage = "https://mevislab.github.io/pythonqt/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
    # ref. https://github.com/MeVisLab/pythonqt/issues/276
    broken = (stdenv.hostPlatform.isDarwin && qt6Support);
  };
})
