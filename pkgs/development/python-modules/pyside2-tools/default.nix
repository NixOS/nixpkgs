{ buildPythonPackage, wrapPython, python, fetchurl, stdenv, cmake, qt5,
  shiboken2, pyside2 }:

stdenv.mkDerivation {
  pname = "pyside2-tools";

  inherit (pyside2) version src;

  postPatch = ''
    cd sources/pyside2-tools
  '';

  nativeBuildInputs = [ cmake wrapPython ];
  propagatedBuildInputs = [ shiboken2 pyside2 ];
  buildInputs = [ python qt5.qtbase ];

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  postInstall = ''
    rm $out/bin/pyside_tool.py
  '';

  postFixup = ''
    wrapPythonPrograms
  '';

  meta = with stdenv.lib; {
    description = "PySide2 development tools";
    license = licenses.gpl2;
    homepage = "https://wiki.qt.io/Qt_for_Python";
    maintainers = with maintainers; [ gebner ];
  };
}
