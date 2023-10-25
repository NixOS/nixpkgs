{ lib, fetchFromGitHub, cmake, buildPythonPackage, pysideGeneratorrunner, pysideShiboken, qt4, mesa, libGL }:

buildPythonPackage rec {
  pname = "pyside";
  version = "1.2.4";
  format = "other";

  src = fetchFromGitHub {
    owner = "PySide";
    repo = "PySide";
    rev = version;
    hash = "sha256-14XbihJRMk9WaeK6NUBV/4OMFZF8EBIJgEJEaCU8Ecg=";
  };

  outputs = [ "out" "dev" ];

  preConfigure = ''
    cmakeFlagsArray=("-DCMAKE_INSTALL_PREFIX=$dev")
  '';

  nativeBuildInputs = [ cmake pysideGeneratorrunner pysideShiboken qt4 ];

  buildInputs = [ mesa libGL ];

  makeFlags = [ "QT_PLUGIN_PATH=${pysideShiboken}/lib/generatorrunner" ];

  dontWrapQtApps = true;

  meta = {
    description = "LGPL-licensed Python bindings for the Qt cross-platform application and UI framework";
    license = lib.licenses.lgpl21;
    homepage = "http://www.pyside.org";
  };
}
