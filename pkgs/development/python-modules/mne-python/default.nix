{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, scipy
, pytestCheckHook
, pytest-timeout
, h5py
, matplotlib
, nibabel
, pandas
, scikit-learn
, decorator
, jinja2
, pooch
, tqdm
, setuptools
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "1.5.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-djVQkj8ktIOxe1xmi+XuIvdS1WdDzozgTJNJhWAhuBo=";
  };

  propagatedBuildInputs = [
    decorator
    jinja2
    matplotlib
    numpy
    pooch
    scipy
    setuptools
    tqdm
  ];

  nativeCheckInputs = [
    h5py
    nibabel
    pandas
    pytestCheckHook
    scikit-learn
    pytest-timeout
  ];

  preCheck = ''
    export HOME=$TMP
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

  # All tests pass, but Pytest hangs afterwards - probably some thread hasn't terminated
  doCheck = false;

  pythonImportsCheck = [
    "mne"
  ];

  meta = with lib; {
    description = "Magnetoencephelography and electroencephalography in Python";
    homepage = "https://mne.tools";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
