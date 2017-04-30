{ lib, fetchurl, cmake, pyside, qt4, pysideShiboken, buildPythonPackage }:

# This derivation provides a Python module and should therefore be called via `python-packages.nix`.
buildPythonPackage rec {
  pname = "pyside-tools";
  version = "0.2.15";
  name = "${pname}-${version}";
  format = "other";

  src = fetchurl {
    url = "https://github.com/PySide/Tools/archive/0.2.15.tar.gz";
    sha256 = "0x4z3aq7jgar74gxzwznl3agla9i1dcskw5gh11jnnwwn63ffzwa";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake pyside qt4 pysideShiboken ];

  meta = {
    description = "Tools for pyside, the LGPL-licensed Python bindings for the Qt cross-platform application and UI framework";
    license = lib.licenses.gpl2;
    homepage = "http://www.pyside.org";
    maintainers = [ lib.maintainers.chaoflow ];
    platforms = lib.platforms.all;
  };
}
