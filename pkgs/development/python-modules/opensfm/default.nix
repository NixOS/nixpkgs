{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  ninja,
  scikit-build-core,
  setuptools,

  # nativeBuildInputs
  cmake,

  # buildInputs
  bashNonInteractive,
  ceres-solver,
  eigen,
  gflags,
  glog,
  gtest,
  lapack,
  metis,
  pybind11,
  suitesparse,

  # dependencies
  cloudpickle,
  exifread,
  flask,
  fpdf2,
  joblib,
  matplotlib,
  networkx,
  numpy,
  opencv-python,
  pillow,
  pyproj,
  python-dateutil,
  pyyaml,
  scipy,
  xmltodict,

  # tests
  pytestCheckHook,

  # passthru
  runCommand,
  srcOnly,
  nix-update-script,
}:

buildPythonPackage (finalAttrs: {
  pname = "opensfm";
  version = "odm-4-unstable-2026-07-01";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mapillary";
    repo = "OpenSfM";
    rev = "a677b6f0648ff3caf439aebbe9aad0ca8abc175b";
    hash = "sha256-Bxpfaj87N2QxP/AczpP3fOl6G8ciMJq5jaaIn7oGR9g=";
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
    ninja
    scikit-build-core
    setuptools
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    bashNonInteractive # for patchShebangs
    ceres-solver
    eigen
    gflags
    glog
    gtest
    lapack
    metis
    pybind11
    suitesparse
  ];

  dependencies = [
    cloudpickle
    exifread
    flask
    fpdf2
    joblib
    matplotlib
    networkx
    numpy
    opencv-python
    pillow
    pyproj
    python-dateutil
    pyyaml
    scipy
    xmltodict
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
  ++ lib.optionals (pythonAtLeast "3.14") [
    # _pickle.UnpicklingError: global 'numpy._core.numeric._frombuffer' is forbidden
    "test_run_all"
    "test_shot_view_ref_count"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_reconstruction_incremental"
    "test_reconstruction_triangulation"
  ];

  pythonImportsCheck = [ "opensfm" ];

  passthru = {
    # https://opensfm.org/docs/using.html#quickstart
    tests = lib.genAttrs' [ "berlin" "lund" ] (
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

    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    maintainers = [
      lib.maintainers.pbsds
      lib.maintainers.SomeoneSerge
    ];
    teams = [ lib.teams.geospatial ];
    license = lib.licenses.bsd2;
    changelog = "https://github.com/mapillary/OpenSfM/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Open source Structure-from-Motion pipeline from Mapillary";
    homepage = "https://opensfm.org/";
  };
})
