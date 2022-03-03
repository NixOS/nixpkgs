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
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = pname;
    rev = "79aa4bdd8bd08dc0cd9e3086d170cedb29ac9760";
    sha256 = "sha256-dHBrkYwLA1OUxUSoe7DysyeEm9Yy70tIJvAsXivdjrM=";
  };
  patches = [
    (fetchpatch {
      url = "https://github.com/mapillary/OpenSfM/pull/872/commits/a76671db11038f3f4dfe5b8f17582fb447ad7dd5.patch";
      sha256 = "sha256-4nizQiZIjucdydOLrETvs1xdV3qiYqAQ7x1HECKvlHs=";
    })
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
  checkInputs = [ pytestCheckHook ];

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
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.bsd2;
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
}
