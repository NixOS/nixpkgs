{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  numpy,
  scipy,
  pytestCheckHook,
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
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "1.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-WPRTX8yB4oP/L5DjSq9M6WOmHJDpQv0sAbuosp7ZGVw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace-fail "--cov-report=" ""  \
      --replace-fail "--cov-branch" ""
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
    pytest-timeout
  ] ++ lib.flatten (builtins.attrValues optional-dependencies);

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
  ];

  pythonImportsCheck = [ "mne" ];

  meta = with lib; {
    description = "Magnetoencephelography and electroencephalography in Python";
    mainProgram = "mne";
    homepage = "https://mne.tools";
    changelog = "https://mne.tools/stable/changes/v${version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [
      bcdarwin
      mbalatsko
    ];
  };
}
