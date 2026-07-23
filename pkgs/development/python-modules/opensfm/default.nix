{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  runCommand,
  srcOnly,
  bashNonInteractive,
  cmake,
  ceres-solver,
  suitesparse,
  metis,
  eigen,
  setuptools,
  pkg-config,
  pybind11,
  numpy,
  pyyaml,
  flask,
  fpdf2,
  opencv-python,
  lapack,
  gtest,
  gflags,
  glog,
  pytestCheckHook,
  networkx,
  pillow,
  exifread,
  pyproj,
  python-dateutil,
  joblib,
  xmltodict,
  cloudpickle,
  scipy,
  sphinx,
  matplotlib,
  scikit-build-core,
  ninja,
}:

buildPythonPackage (finalAttrs: {
  pname = "opensfm";
  version = "0.5.1-unstable-2026-05-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = "OpenSfM";
    rev = "1dc5b95b5c8c4cadd653bdc9f6eb97c0ac1602ba";
    sha256 = "sha256-K3+H8QSzTxIGAtYDGqOuJFTVaqk+B/R/MDMepJ/bRxY=";
  };

  patches = [
    ./0001-cmake-use-system-pybind11.patch
    ./0002-cmake-find-system-distributed-gtest.patch
    ./0003-fix-scripts.patch
  ];

  postPatch = ''
    # devendor
    rm opensfm/src/cmake/FindGlog.cmake # (ubuntu 20.04 fallback)
    rm opensfm/src/cmake/FindGflags.cmake
    rm -rf  opensfm/src/third_party/gtest
    rm -rf  opensfm/src/third_party/pybind11

    # HAHOG is the default descriptor.
    # We'll test both HAHOG and SIFT because this is
    # where segfaults might be introduced in future
    echo 'feature_type: SIFT' >> data/berlin/config.yaml
    echo 'feature_type: HAHOG' >> data/lund/config.yaml

    # make opensfm correctly import glog headers
    export CXXFLAGS=-DGLOG_USE_GLOG_EXPORT

    # we use the pyproject.toml
    rm setup.py
  '';

  dontUseCmakeConfigure = true;

  build-system = [
    setuptools
    scikit-build-core
    ninja
  ];

  nativeBuildInputs = [
    cmake
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
    bashNonInteractive # for patchShebangs
  ];

  dependencies = [
    numpy
    scipy
    pyyaml
    flask
    fpdf2
    opencv-python
    networkx
    pillow
    matplotlib
    exifread
    pyproj
    python-dateutil
    joblib
    xmltodict
    cloudpickle
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # pyproject.toml has yet to enable the [project.scripts]
  postInstall = ''
    if [[ -d $out/bin ]]; then
      echo >&2 "ERROR: $out/bin found, re-check our assumptions"
      false
    fi
    install -Dt $out/bin -m +rwx bin/opensfm
    install -Dt $out/bin -m +rwx bin/opensfm_run_all
    install -Dt $out/bin -m +rwx bin/opensfm_main.py
  '';

  disabledTests = [
    # flaky
    "test_match_candidates_from_metadata_bow"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_reconstruction_incremental"
    "test_reconstruction_triangulation"
  ];

  pythonImportsCheck = [ "opensfm" ];

  # https://opensfm.org/docs/using.html#quickstart
  passthru.tests = lib.genAttrs' [ "berlin" "lund" ] (
    name:
    lib.nameValuePair "integration-test-${name}" (
      runCommand "opensfm-integration-test-${name}"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          set -euo pipefail
          opensfm --help
          cp -r ${srcOnly finalAttrs.finalPackage}/data/${name} data
          chmod -R +w data/
          bash -x $(command -v opensfm_run_all) data/
          if [[ -s data/camera_models.json && -s data/undistorted/reconstruction.json ]]; then
            touch $out
          fi
        ''
    )
  );

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
