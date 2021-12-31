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
    repo = "OpenSfM";
    # Fixing by commit-id until the upstream issues are solved
    rev = "2a1c9be07f47f6e26f87fedf8275fcf8ff7b8487";
    sha256 = "sha256-CARPFuYypgV1YcqZp//Qws8YrV25Z+w/dWB7MbFAKys=";
    fetchSubmodules = true;
  };
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
  patches = [
    ./fix-cmake.patch
    ./fix-scripts.patch
    ./fix-report-generation.patch
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
  pythonImportsCheck = [ "opensfm" ];
  meta = {
    maintainers = [ lib.maintainers.SomeoneSerge ];
    license = lib.licenses.bsd2;
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
}
