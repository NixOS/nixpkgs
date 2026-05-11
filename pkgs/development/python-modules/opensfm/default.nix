{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  cmake,
  opencv-python,
  ceres-solver,
  scikit-build-core,
  ninja,
  pkg-config,
  pybind11,
  numpy,
  pyyaml,
  gtest,
  pytestCheckHook,
  networkx,
  pillow,
  exifread,
  gpxpy,
  pyproj,
  python-dateutil,
  joblib,
  xmltodict,
  cloudpickle,
  scipy,
  matplotlib,
  flask,
  fpdf2,
  pythonAtLeast,
}:

buildPythonPackage (finalAttrs: {
  pname = "opensfm";
  version = "0.5.1-unstable-2026-02-11";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = "OpenSfM";
    rev = "3a2041e28f10afe8e43ca6602f8dcf7db4679f5b";
    hash = "sha256-5Ufzn2DUjsmE8S5Ot3Qs7n0fJuzkVkH2ayX3jxtc4E4=";
  };

  patches = [
    ./use-system-dependencies.patch
  ];

  postPatch = ''
    rm opensfm/src/cmake/FindGlog.cmake
    rm opensfm/src/cmake/FindGflags.cmake

    # HAHOG is the default descriptor.
    # We'll test both HAHOG and SIFT because this is
    # where segfaults might be introduced in future
    echo 'feature_type: SIFT' >> data/berlin/config.yaml
    echo 'feature_type: HAHOG' >> data/lund/config.yaml

    # add shebang to opensfm_main.py
    sed -i '1i#!/usr/bin/env python' bin/opensfm_main.py
  '';

  build-system = [
    scikit-build-core
    pybind11
    ninja
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    ceres-solver
    gtest
    pybind11
  ];

  dependencies = [
    numpy
    scipy
    pyyaml
    opencv-python
    networkx
    pillow
    matplotlib
    flask
    fpdf2
    exifread
    gpxpy
    pyproj
    python-dateutil
    joblib
    xmltodict
    cloudpickle
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  dontUseCmakeConfigure = true;

  __structuredAttrs = true;

  env = {
    CMAKE_ARGS = "-DPYBIND11_FINDPYTHON=ON";
    CXXFLAGS = "-DGLOG_USE_GLOG_EXPORT";
  };

  postInstall = ''
    install -Dm755 bin/opensfm_main.py $out/bin/opensfm
    install -Dm755 bin/opensfm_run_all $out/bin/opensfm_run_all
  '';

  disabledTests = [
    "test_run_all" # Matplotlib issues. Broken integration is less useless than a broken build
    "test_match_candidates_from_metadata_bow" # flaky
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # Fragile ref count assertion; fails with Python 3.14+
    "test_shot_view_ref_count"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_reconstruction_incremental"
    "test_reconstruction_triangulation"
  ];

  pythonImportsCheck = [ "opensfm" ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [
      lib.maintainers.pbsds
      lib.maintainers.SomeoneSerge
    ];
    license = lib.licenses.bsd2;
    changelog = "https://github.com/mapillary/OpenSfM/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
})
