{ lib
, buildPythonPackage
, fetchFromGitHub
, cmake
, opencv
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
}:

buildPythonPackage rec {
  pname = "OpenSfM";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = pname;
    rev = "79aa4bdd8bd08dc0cd9e3086d170cedb29ac9760";
    sha256 = "sha256-mEwqT7jzxIhN5IrCFEGHaJGHN2me8j3rMT1hUdGpg2Q=";
    # FIXME: rm
    fetchSubmodules = true;
  };
  patches = [
    ./fix-cmake.patch
    ./fix-scripts.patch
  ];
  postPatch = ''
    # Use upstream means of discovery instead
    # (exported cmake targets and pkg-config).
    # Also see the ./fix-cmake.patch
    rm opensfm/src/cmake/FindEigen.cmake
    rm opensfm/src/cmake/FindCeres.cmake
    rm opensfm/src/cmake/FindGlog.cmake
    rm opensfm/src/cmake/FindGflags.cmake
    rm -rf opensfm/src/third_party/gtest

    # HAHOG is the default descriptor.
    # We'll test both HAHOG and SIFT because this is
    # where segfaults might be introduced in future
    echo 'feature_type: SIFT' >> data/berlin/config.yaml
    echo 'feature_type: HAHOG' >> data/lund/config.yaml
  '';

  nativeBuildInputs = [ cmake pkg-config sphinx ];
  buildInputs = [
    opencv
    ceres-solver.dev
    suitesparse
    metis
    eigen
    lapack
    gflags
    gtest
    glog
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

  pythonImportsCheck = [ "opensfm" ];

  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.bsd2;
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
    platforms = lib.platforms.linux;
  };
}
