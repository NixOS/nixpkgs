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
, repoze-lru
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
  pname = "opensfm";
  version = "unstable-2023-12-09";

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = "OpenSfM";
    rev = "7f170d0dc352340295ff480378e3ac37d0179f8e";
    sha256 = "sha256-l/HTVenC+L+GpMNnDgnSGZ7+Qd2j8b8cuTs3SmORqrg=";
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

    sed -i -e 's/^.*BuildDoc.*$//' setup.py
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
    opencv4.cxxdev
    networkx
    pillow
    matplotlib
    fpdf
    exifread
    gpxpy
    pyproj
    python-dateutil
    joblib
    repoze-lru
    xmltodict
    cloudpickle
  ];
  nativeCheckInputs = [ pytestCheckHook ];

  dontUseCmakeBuildDir = true;
  cmakeFlags = [
    "-Bcmake_build"
    "-Sopensfm/src"
  ];

  disabledTests = [
    "test_run_all" # Matplotlib issues. Broken integration is less useless than a broken build
  ] ++ lib.optionals stdenv.isDarwin [
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
