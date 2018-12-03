{ stdenv, fetchurl, python, qmake,
  qtwebengine, qtxmlpatterns,
  qttools, unzip }:

stdenv.mkDerivation rec {
  version = "3.2";
  name = "python-qt-${version}";

  src = fetchurl {
    url="mirror://sourceforge/pythonqt/PythonQt${version}.zip";
    sha256="13hzprk58m3yj39sj0xn6acg8796lll1256mpd81kw0z3yykyl8c";
  };

  hardeningDisable = [ "all" ];

  nativeBuildInputs = [ qmake qtwebengine  qtxmlpatterns qttools ];

  buildInputs = [ python unzip ];

  qmakeFlags = [ "PythonQt.pro"
                 "INCLUDEPATH+=${python}/include/python3.6"
                 "PYTHON_PATH=${python}/bin"
                 "PYTHON_LIB=${python}/lib"];

  unpackCmd = "unzip $src";

  installPhase = ''
    mkdir -p $out/include/PythonQt
    cp -r ./lib $out
    cp -r ./src/* $out/include/PythonQt
    cp extensions/PythonQt_QtAll/PythonQt_QtAll.h $out/include/PythonQt
    cp extensions/PythonQt_QtAll/PythonQt_QtAll.cpp $out/include/PythonQt
  '';

  meta = with stdenv.lib; {
    description = "PythonQt is a dynamic Python binding for the Qt framework. It offers an easy way to embed the Python scripting language into your C++ Qt applications.";
    homepage = http://pythonqt.sourceforge.net/;
    license = licenses.lgpl21;
    platforms = platforms.all;
    maintainers = with maintainers; [ hlolli ];
  };
}
