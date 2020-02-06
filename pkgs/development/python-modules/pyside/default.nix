{ lib, fetchurl, cmake, buildPythonPackage, pysideGeneratorrunner, pysideShiboken, qt4, mesa, libGL }:

# This derivation provides a Python module and should therefore be called via `python-packages.nix`.
buildPythonPackage rec {
  pname = "pyside";
  version = "1.2.4";
  format = "other";

  src = fetchurl {
    url = "https://github.com/PySide/PySide/archive/${version}.tar.gz";
    sha256 = "90f2d736e2192ac69e5a2ac798fce2b5f7bf179269daa2ec262986d488c3b0f7";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake pysideGeneratorrunner pysideShiboken qt4 ];

  buildInputs = [ mesa libGL ];

  makeFlags = [ "QT_PLUGIN_PATH=${pysideShiboken}/lib/generatorrunner" ];

  meta = {
    description = "LGPL-licensed Python bindings for the Qt cross-platform application and UI framework";
    license = lib.licenses.lgpl21;
    homepage = http://www.pyside.org;
  };
}
