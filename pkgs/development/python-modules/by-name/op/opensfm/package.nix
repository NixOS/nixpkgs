{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  cmake,
  opencv4,
  ceres-solver,
  suitesparse,
  metis,
  eigen,
  setuptools,
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
  repoze-lru,
  xmltodict,
  distutils,
  cloudpickle,
  scipy,
  sphinx,
  matplotlib,
  fpdf,
}:

buildPythonPackage rec {
  pname = "opensfm";
  version = "unstable-2023-12-09";
  pyproject = true;

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
    ./0005-fix-numpy-2-test-failures.patch # not upstreamed due to cla, but you're free upstream it -@pbsds
    ./fix-scripts.patch
  ];

  postPatch = ''
    substituteInPlace opensfm/src/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0)" "cmake_minimum_required(VERSION 3.10)"

    rm opensfm/src/cmake/FindGlog.cmake
    rm opensfm/src/cmake/FindGflags.cmake

    # HAHOG is the default descriptor.
    # We'll test both HAHOG and SIFT because this is
    # where segfaults might be introduced in future
    echo 'feature_type: SIFT' >> data/berlin/config.yaml
    echo 'feature_type: HAHOG' >> data/lund/config.yaml

    # make opensfm correctly import glog headers
    export CXXFLAGS=-DGLOG_USE_GLOG_EXPORT

    sed -i -e 's/^.*BuildDoc.*$//' setup.py
  '';

  build-system = [ setuptools ];

  nativeBuildInputs = [
    cmake
    pkg-config
    sphinx
  ];

  buildInputs = [
    ceres-solver
    suitesparse
    metis
    eigen
    lapack
    gflags
    gtest
    glog
    pybind11
  ];

  dependencies = [
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

  nativeCheckInputs = [
    pytestCheckHook
    distutils
  ];

  dontUseCmakeBuildDir = true;
  cmakeFlags = [
    "-Bcmake_build"
    "-Sopensfm/src"
  ];

  disabledTests = [
    "test_run_all" # Matplotlib issues. Broken integration is less useless than a broken build
    "test_match_candidates_from_metadata_bow" # flaky
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_reconstruction_incremental"
    "test_reconstruction_triangulation"
  ];

  pythonImportsCheck = [ "opensfm" ];

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [
      lib.maintainers.pbsds
      lib.maintainers.SomeoneSerge
    ];
    license = lib.licenses.bsd2;
    changelog = "https://github.com/mapillary/OpenSfM/blob/${src.rev}/CHANGELOG.md";
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
}
