{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  python3,
  qmake,
  qtwebengine,
  qtxmlpatterns,
  qttools,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "python-qt";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Yz7w5Gs0W3ilrZXjkC+wXLCCXWTKkhCpWXbg+PshXKI=";
  };

  patches = [
    # fix a -Werror=format-security. was merged upstream, so can be removed on next release.
    (fetchpatch {
      name = "fix-format-security.patch";
      url = "https://github.com/MeVisLab/pythonqt/pull/197/commits/c35d1efd00b83e0ebd826d7ed8454f3684ddffff.patch";
      hash = "sha256-WJBLPdMemuKlZWoqYVU9TXldoDpaBm84RxkepIaocUQ=";
    })
    # same for darwin. not yet merged upstream.
    (fetchpatch {
      name = "fix-format-security-darwin.patch";
      url = "https://github.com/MeVisLab/pythonqt/pull/207/commits/4d5a742bccdc4e98ad862f028b96debe4c195906.patch";
      hash = "sha256-u3aDi9ncv7CuKYrz5JC1s1Xjy4d9z07mEqQmobtdzKU=";
    })
  ];

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

  postFixup = lib.optionalString stdenv.isDarwin ''
    install_name_tool -id \
      $out/lib/libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.dylib \
      $out/lib/libPythonQt-Qt5-Python3.${python3.sourceVersion.minor}.dylib
    install_name_tool -id \
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
