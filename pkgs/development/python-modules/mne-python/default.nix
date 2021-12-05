{ lib, buildPythonPackage, fetchFromGitHub, isPy27, numpy, scipy
, pytestCheckHook, pytest-cov, pytest-timeout, h5py, matplotlib, nibabel, pandas
, scikit-learn }:

buildPythonPackage rec {
  pname = "mne-python";
  version = "0.24.0";

  disabled = isPy27;

  # PyPI dist insufficient to run tests
  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1982y54n7q9pl28haca0vx6cjrk2a8cj24piaj8j31f09rynn8k0";
  };

  propagatedBuildInputs = [ numpy scipy ];

  # all tests pass, but Pytest hangs afterwards - probably some thread hasn't terminated
  doCheck = false;
  checkInputs = [
    pytestCheckHook
    pytest-cov
    pytest-timeout
    h5py
    matplotlib
    nibabel
    pandas
    scikit-learn
  ];
  preCheck = ''
    export HOME=$TMP
    export MNE_SKIP_TESTING_DATASET_TESTS=true
    export MNE_SKIP_NETWORK_TESTS=1
  '';

  pythonImportsCheck = [ "mne" ];

  meta = with lib; {
    homepage = "https://mne.tools";
    description = "Magnetoencephelography and electroencephalography in Python";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
