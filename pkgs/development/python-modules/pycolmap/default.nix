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
  mypy,
  enlighten,
  pytestCheckHook,
}:
let
  # Add COLMAP's pybind11 fixes, see COLMAP's pyproject.toml.
  # TODO: remove when https://github.com/sizmailov/pybind11-stubgen/pull/263 is merged
  # Generated with; git diff ac46c10e229f1fc570600a14a644238b86ae4f99 a138210fd4f0b548f5195421a9b5b31091078ad6
  pybind11-stubgen-pybind-3 = pybind11-stubgen.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [ ./pybind11-stubgen-fix-pybind-3.0.0.patch ];
  });
in
buildPythonPackage {
  pname = "pycolmap";

  inherit (colmap) src version;

  patches = (colmap.patches or [ ]) ++ [ ./remove-version-bounds.patch ];

  pyproject = true;

  dontUseCmakeConfigure = true;
  dontWrapQtApps = true;

  build-system = [
    scikit-build-core
    ruff
    ninja
    pybind11
    pybind11-stubgen-pybind-3
    cmake
    clang-tools
    perl
  ];

  cmakeFlags = [ "-DGENERATE_STUBS=ON" ];

  buildInputs = [ colmap ] ++ colmap.depsAlsoForPycolmap;

  dependencies = [ numpy ];

  pythonImportsCheck = "pycolmap";

  nativeCheckInputs = [
    pytestCheckHook
    mypy
    enlighten
  ];

  enabledTestPaths = [ "python/examples" ];

  postInstallCheck = ''
    python -m mypy --package pycolmap --implicit-optional
  '';

  meta = with lib; {
    description = "Structure-From-Motion and Multi-View Stereo pipeline";
    longDescription = ''
      COLMAP is a general-purpose Structure-from-Motion (SfM) and Multi-View Stereo (MVS) pipeline
      with a graphical and command-line interface.
    '';
    homepage = "https://colmap.github.io/pycolmap/index.html";
    license = licenses.bsd3;
    platforms = platforms.unix;
    maintainers = with maintainers; [ chpatrick ];
  };
}
