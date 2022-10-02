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
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "1.1.1";

  # PyPI dist insufficient to run tests
  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-VM7sKcQeAeK20r4/jehhGlvBSHhYwA2SgsNL5Oa/Hug=";
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

  checkInputs = [
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

  # all tests pass, but Pytest hangs afterwards - probably some thread hasn't terminated
  doCheck = false;

  pythonImportsCheck = [ "mne" ];

  meta = with lib; {
    homepage = "https://mne.tools";
    description = "Magnetoencephelography and electroencephalography in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
