{ lib, buildPythonPackage, setuptools, cmake, colmap, boost, numpy
, scikit-build-core, ruff, ninja, pybind11, pybind11-stubgen, clang-tools, perl,
}:
let
  # TODO: remove when https://github.com/sizmailov/pybind11-stubgen/pull/263 is merged
  # Generated with; git diff ac46c10e229f1fc570600a14a644238b86ae4f99 d85d060d3ea71845186d1015e8d9ec68b292ffb5
  pybind11-stubgen-pybind-3 = pybind11-stubgen.overrideAttrs (old: {
    patches = (old.patches or [ ])
      ++ [ ./pybind11-stubgen-fix-pybind-3.0.0.patch ];
  });
in buildPythonPackage {
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
