{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  numpy,
  scipy,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-timeout,
  matplotlib,
  decorator,
  jinja2,
  pooch,
  tqdm,
  packaging,
  lazy-loader,
  h5io,
  pymatreader,
  pythonOlder,
  procps,
  optipng,
}:

buildPythonPackage rec {
  pname = "mne";
  # https://github.com/mne-tools/mne-python/pull/13049 is required to build, it does not apply if fetchpatch'ed
  stableVersion = "1.9.0";
  version = "1.9.0-unstable-2025-05-01";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    rev = "5df1721b488070e3b3928dface9dd0b8c39a3bef";
    hash = "sha256-BCLejk0sVym+HRCfnTl5LTOGUMrQdxZbqhrCnIpzsvM=";
  };

  env.SETUPTOOLS_SCM_PRETEND_VERSION = stableVersion;

  postPatch = ''
    substituteInPlace doc/conf.py \
      --replace-fail '"optipng"' '"${lib.getExe optipng}"'
    substituteInPlace mne/utils/config.py \
      --replace-fail '"free"'   '"${lib.getExe' procps "free"}"' \
      --replace-fail '"sysctl"' '"${lib.getExe' procps "sysctl"}"'
  '';

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    numpy
    scipy
    matplotlib
    tqdm
    pooch
    decorator
    packaging
    jinja2
    lazy-loader
  ];

  optional-dependencies.hdf5 = [
    h5io
    pymatreader
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
    pytest-timeout
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

  disabledTests = [
    # requires qtbot which is unmaintained/not in Nixpkgs:
    "test_plotting_scalebars"
    # tries to write a datetime object to hdf5, which fails:
    "test_hitachi_basic"
    # flaky
    "test_fine_cal_systems"
    "test_simulate_raw_bem"
  ];

  pytestFlagsArray = [
    "-m 'not (slowtest or ultraslowtest or pgtest)'"
    # removes 700k lines form pytest log, remove this when scipy is at v1.17.0
    "--disable-warnings"
  ];

  pythonImportsCheck = [ "mne" ];

  meta = with lib; {
    description = "Magnetoencephelography and electroencephalography in Python";
    mainProgram = "mne";
    homepage = "https://mne.tools";
    changelog = "https://mne.tools/stable/changes/${stableVersion}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      bcdarwin
      mbalatsko
    ];
  };
}
