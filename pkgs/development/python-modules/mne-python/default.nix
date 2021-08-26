{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scipy
, pytestCheckHook
, pytest-cov
, pytest-timeout
, h5py
, matplotlib
, nibabel
, pandas
, scikit-learn
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "0.23.2";

  disabled = isPy27;

  # PyPI dist insufficient to run tests
  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "1y6xypfzq7a3ffzwlbqspyzvijr6ihgfzgvhajs16d74pxhdkg74";
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
