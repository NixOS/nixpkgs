{ lib
, buildPythonPackage
, fetchFromGitHub
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
, defusedxml
, h5io
, pymatreader
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = "mne-python";
    rev = "refs/tags/v${version}";
    hash = "sha256-djVQkj8ktIOxe1xmi+XuIvdS1WdDzozgTJNJhWAhuBo=";
  };

  patches = [
    ./disable-pytest-cov.patch
  ];

  nativeBuildInputs = [
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
    defusedxml
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
    export HOME=$TMP
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

  disabledTests = [
    # touches internet
    "test_adjacency_matches_ft"
    "test_fetch_uncompressed_file"
  ];

  pythonImportsCheck = [
    "mne"
  ];

  meta = with lib; {
    description = "Magnetoencephelography and electroencephalography in Python";
    homepage = "https://mne.tools";
    changelog = "https://mne.tools/stable/whats_new.html";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin mbalatsko ];
  };
}
