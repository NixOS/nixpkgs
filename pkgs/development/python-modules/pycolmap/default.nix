{
  lib,
  buildPythonPackage,
  setuptools,
  cmake,
  colmap,
  boost,
  numpy,
  scikit-build-core,
  ruff,
  ninja,
  pybind11,
  pybind11-stubgen,
  clang-tools,
  perl,
}:
buildPythonPackage {
  pname = "pycolmap";

  inherit (colmap) src version;

  patches = colmap.patches ++ [ ./remove-version-bounds.patch ];

  pyproject = true;

  dontUseCmakeConfigure = true;
  dontWrapQtApps = true;

  build-system = [
    scikit-build-core
    ruff
    ninja
    pybind11
    pybind11-stubgen
    cmake
    clang-tools
    perl
  ];

  buildInputs = [ colmap ] ++ colmap.pythonDeps;

  dependencies = [ numpy ];

  pythonImportsCheck = "pycolmap";

  meta = with lib; {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    homepage = "https://colmap.github.io/pycolmap/index.html";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      chpatrick
    ];
  };
}
