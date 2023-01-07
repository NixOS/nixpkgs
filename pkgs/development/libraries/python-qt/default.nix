{ lib, stdenv, fetchFromGitHub, fetchpatch, python, qmake,
  qtwebengine, qtxmlpatterns,
  qttools, unzip }:

stdenv.mkDerivation rec {
  pname = "python-qt";
  version = "3.3.0";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${version}";
    hash = "sha256-zbQ6X4Q2/QChaw3GAz/aVBj2JjWEz52YuPuHbBz935k=";
  };

  patches = [
    (fetchpatch {
      name = "remove-unneeded-pydebug-include.patch";
      url = "https://github.com/MeVisLab/pythonqt/commit/a93104dea4d9c79351276ec963e931ca617625ec.patch";
      includes = [ "src/PythonQt.cpp" ];
      hash = "sha256-Tc4+6dIdvrda/z3Nz1s9Xz+ZWJLV2BQh8i552UynSI0=";
    })
  ];

  # https://github.com/CsoundQt/CsoundQt/blob/develop/BUILDING.md#pythonqt
  postPatch = ''
    substituteInPlace build/python.prf \
      --replace "unix:PYTHON_VERSION=2.7" "unix:PYTHON_VERSION=${python.pythonVersion}"
  '';

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [ qmake qtwebengine qtxmlpatterns qttools unzip ];

  buildInputs = [ python ];

  qmakeFlags = [
    "PythonQt.pro"
    "PYTHON_DIR=${python}"
  ];

  dontWrapQtApps = true;

  unpackCmd = "unzip $src";

  installPhase = ''
    mkdir -p $out/include/PythonQt
    cp -r ./lib $out
    cp -r ./src/* $out/include/PythonQt
    cp -r ./build $out/include/PythonQt
    cp -r ./extensions $out/include/PythonQt
  '';

  meta = with lib; {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications";
    homepage = "http://pythonqt.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
  };
}
