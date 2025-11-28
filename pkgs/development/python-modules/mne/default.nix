{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  numpy,
  scipy,
  flaky,
  pandas,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-timeout,
  writableTmpDirAsHomeHook,
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
  version = "1.10.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    tag = "v${version}";
    hash = "sha256-K99yjWpX7rt6Isp0ao0NJcUu7GBRNKVz2i+xVt2HBNY=";
  };

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
    flaky
    pandas
    pytestCheckHook
    pytest-cov-stub
    pytest-timeout
    writableTmpDirAsHomeHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  preCheck = ''
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

  pytestFlag = [
    # removes 700k lines from pytest log, remove this when scipy is at v1.17.0
    "--disable-warnings"
  ];

  disabledTestMarks = [
    "slowtest"
    "ultraslowtest"
    "pgtest"
  ];

  pythonImportsCheck = [ "mne" ];

  meta = {
    description = "Magnetoencephelography and electroencephalography in Python";
    mainProgram = "mne";
    homepage = "https://mne.tools";
    changelog = "https://mne.tools/stable/changes/v${lib.versions.majorMinor version}.html";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      bcdarwin
      mbalatsko
    ];
  };
}
