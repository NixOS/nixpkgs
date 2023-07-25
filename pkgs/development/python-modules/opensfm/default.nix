{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, cmake
, opencv4
, ceres-solver
, suitesparse
, metis
, eigen
, pkg-config
, pybind11
, numpy
, pyyaml
, lapack
, gtest
, gflags
, glog
, pytestCheckHook
, networkx
, pillow
, exifread
, gpxpy
, pyproj
, python-dateutil
, joblib
, repoze_lru
, xmltodict
, cloudpickle
, scipy
, sphinx
, matplotlib
, fpdf
,
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
  version = "unstable-2022-03-10";

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = pname;
    rev = "536b6e1414c8a93f0815dbae85d03749daaa5432";
    sha256 = "Nfl20dFF2PKOkIvHbRxu1naU+qhz4whLXJvX5c5Wnwo=";
  };
  patches = [
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

  nativeBuildInputs = [ cmake pkg-config sphinx ];
  buildInputs = [
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
  nativeCheckInputs = [ pytestCheckHook ];

  dontUseCmakeBuildDir = true;
  cmakeFlags = [
    "-Bcmake_build"
    "-Sopensfm/src"
  ];

  disabledTests = lib.optionals stdenv.isDarwin [
    "test_reconstruction_incremental"
    "test_reconstruction_triangulation"
  ];

  pythonImportsCheck = [ "opensfm" ];

  meta = {
    broken = stdenv.isDarwin;
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.bsd2;
    changelog = "https://github.com/mapillary/OpenSfM/blob/${src.rev}/CHANGELOG.md";
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
}
