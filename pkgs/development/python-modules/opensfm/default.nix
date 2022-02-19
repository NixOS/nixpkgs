{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  opencv,
  opencv4,
  ceres-solver,
  suitesparse,
  metis,
  eigen,
  pkg-config,
  pybind11,
  numpy,
  pyyaml,
  lapack,
  gtest,
  gflags,
  glog,
  pytestCheckHook,
  networkx,
  pillow,
  exifread,
  gpxpy,
  pyproj,
  python-dateutil,
  joblib,
  repoze_lru,
  xmltodict,
  cloudpickle,
  scipy,
  sphinx,
  matplotlib,
  fpdf,
}:

let
  ceresSplit = (builtins.length ceres-solver.outputs) > 1;
  ceres' =
    if ceresSplit
    then ceres-solver.dev
    else ceres-solver;
in
  buildPythonPackage rec {
    pname = "OpenSfM";
    version = "0.5.2";

    src = fetchFromGitHub {
      owner = "mapillary";
      repo = pname;
      rev = "79aa4bdd8bd08dc0cd9e3086d170cedb29ac9760";
      sha256 = "sha256-dHBrkYwLA1OUxUSoe7DysyeEm9Yy70tIJvAsXivdjrM=";
    };
    patches = [
      ./0001-fix-cmake-Eigen-Ceres-via-native-cmake-targets.patch
      ./0002-cmake-find-system-distributed-gtest.patch
      ./0003-cmake-use-system-pybind11.patch
      ./0004-pybind_utils.h-conflicts-with-nixpkgs-pybind.patch
      ./fix-scripts.patch
    ];
    postPatch = ''
      rm opensfm/src/cmake/FindGlog.cmake
      rm opensfm/src/cmake/FindGflags.cmake

      # HAHOG is the default descriptor.
      # We'll test both HAHOG and SIFT because this is
      # where segfaults might be introduced in future
      echo 'feature_type: SIFT' >> data/berlin/config.yaml
      echo 'feature_type: HAHOG' >> data/lund/config.yaml
    '';

    nativeBuildInputs = [cmake pkg-config sphinx];
    buildInputs = [
      opencv
      ceres'
      suitesparse
      metis
      eigen
      lapack
      gflags
      gtest
      glog
      pybind11
    ];
    propagatedBuildInputs = [
      numpy
      scipy
      pyyaml
      opencv4
      networkx
      pillow
      matplotlib
      fpdf
      exifread
      gpxpy
      pyproj
      python-dateutil
      joblib
      repoze_lru
      xmltodict
      cloudpickle
    ];
    checkInputs = [pytestCheckHook];

    dontUseCmakeBuildDir = true;
    cmakeFlags = [
      "-Bcmake_build"
      "-Sopensfm/src"
    ];

    pythonImportsCheck = ["opensfm"];

    meta = {
      maintainers = [lib.maintainers.SomeoneSerge];
      license = lib.licenses.bsd2;
      description = "Open source Structure-from-Motion pipeline from Mapillary";
      homepage = "https://opensfm.org/";
      platforms = lib.platforms.linux;
    };
  }
