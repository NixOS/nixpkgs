{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, numpy
, scipy
, pytestCheckHook
, pytestcov
, pytest-timeout
, h5py
, matplotlib
, nibabel
, pandas
, scikitlearn
}:

buildPythonPackage rec {
  pname = "mne-python";
  version = "0.21.2";

  disabled = isPy27;

  # PyPI dist insufficient to run tests
  src = fetchFromGitHub {
    owner = "mne-tools";
    repo = pname;
    rev = "v${version}";
    sha256 = "18nfdbkffmxzkkbp3d4w8r2kfi0sxip3hy997d3mx6dy74jc7nmg";
  };

  propagatedBuildInputs = [ numpy scipy ];

  # all tests pass, but Pytest hangs afterwards - probably some thread hasn't terminated
  doCheck = false;
  checkInputs = [
    pytestCheckHook
    pytestcov
    pytest-timeout
    h5py
    matplotlib
    nibabel
    pandas
    scikitlearn
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
