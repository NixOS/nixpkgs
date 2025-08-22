{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  numpy,
  pbr,
  setuptools,
  fastremap,
}:

let
  version = "2.1.0";
in
buildPythonPackage {
  name = "fill-voids";
  format = "pyproject";

  src = fetchPypi {
    inherit version;
    pname = "fill_voids";
    hash = "sha256-Y/dvfb3Yy18w6ihBoxYk66RhLZEhHW/3TSMX9E1EmGA=";
  };

  build-system = [
    cython
    numpy
    pbr
    setuptools
  ];

  dependencies = [
    numpy
    fastremap
  ];

  pythonImportsCheck = [
    "fill_voids"
  ];

  meta = {
    description = "Remap, mask, renumber, unique, and in-place transposition of 3D labeled images and point clouds";
    homepage = "https://github.com/seung-lab/fill_voids";
    license = with lib.licenses; [
      gpl3
      lgpl3
    ];
    maintainers = with lib.maintainers; [ afermg ];
    platforms = lib.platforms.all;
  };
}
