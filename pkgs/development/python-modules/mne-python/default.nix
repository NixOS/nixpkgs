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
  version = "1.7.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-piCFynpKh7gTWIGh2g0gJICLS+eg/0XAxaDkyu7v5vs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace-fail "--cov-report=" ""  \
      --replace-fail "--cov-branch" ""
  '';

  nativeBuildInputs = [
    hatchling
    hatch-vcs
  ];

  propagatedBuildInputs = [
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

  passthru.optional-dependencies.hdf5 = [
    h5io
    pymatreader
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

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
