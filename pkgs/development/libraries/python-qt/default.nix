{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  qmake,
  qtwebengine,
  qtxmlpatterns,
  qttools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "python-qt";
  version = "3.5.6";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-+cmwTTNmy87yuHukesA+nukM2RjMTHsvIbeG7J7X8ig=";
  };

  nativeBuildInputs = [
    qmake
    qttools
    qtxmlpatterns
    qtwebengine
  ];

  buildInputs = [ python3 ];

  qmakeFlags = [
    "PYTHON_DIR=${python3}"
    "PYTHON_VERSION=3.${python3.sourceVersion.minor}"
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
    install_name_tool -id \
      $out/lib/libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.dylib \
      $out/lib/libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.dylib
    install_name_tool -change \
               libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.3.dylib \
      $out/lib/libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.3.dylib \
      -id \
      $out/lib/libPythonQt_QtAll-Qt5-Python3.${python3.sourceVersion.minor}.dylib \
      $out/lib/libPythonQt_QtAll-Qt5-Python3.${python3.sourceVersion.minor}.dylib
  '';

  meta = with lib; {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    homepage = "https://pythonqt.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
  };
})
