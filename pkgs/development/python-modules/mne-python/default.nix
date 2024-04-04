{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, numpy
, scipy
, pytestCheckHook
, pytest-timeout
, pytest-harvest
, matplotlib
, decorator
, jinja2
, pooch
, tqdm
, packaging
, importlib-resources
, lazy-loader
, h5io
, pymatreader
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "1.6.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-U1aMqcUZ3BcwqwOYh/qfG5PhacwBVioAgNc52uaoJL0";
  };

  postPatch = ''
    substituteInPlace pyproject.toml  \
      --replace "--cov-report=" ""  \
      --replace "--cov-branch" ""
  '';

  nativeBuildInputs = [
    setuptools
    setuptools-scm
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
  ] ++ lib.optionals (pythonOlder "3.9") [
    importlib-resources
  ];

  passthru.optional-dependencies = {
    hdf5 = [
      h5io
      pymatreader
    ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
    pytest-harvest
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  preCheck = ''
    export HOME=$(mktemp -d)
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

  pythonImportsCheck = [
    "mne"
  ];

  meta = with lib; {
    description = "Magnetoencephelography and electroencephalography in Python";
    mainProgram = "mne";
    homepage = "https://mne.tools";
    changelog = "https://mne.tools/stable/changes/v${version}.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin mbalatsko ];
  };
}
