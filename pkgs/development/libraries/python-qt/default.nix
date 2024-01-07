{ lib, stdenv, fetchFromGitHub, fetchpatch, python, qmake,
  qtwebengine, qtxmlpatterns,
  qttools, unzip }:

stdenv.mkDerivation rec {
  pname = "python-qt";
  version = "3.4.2";

  src = fetchFromGitHub {
    owner = "MeVisLab";
    repo = "pythonqt";
    rev = "v${version}";
    hash = "sha256-xJYOD07ACOKtY3psmfHNSCjm6t0fr8JU9CrL0w5P5G0=";
  };

  # https://github.com/CsoundQt/CsoundQt/blob/develop/BUILDING.md#pythonqt
  postPatch = ''
    substituteInPlace build/python.prf \
      --replace "PYTHON_VERSION=2.7" "PYTHON_VERSION=${python.pythonVersion}"
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
    homepage = "https://pythonqt.sourceforge.net/";
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
  };
}
