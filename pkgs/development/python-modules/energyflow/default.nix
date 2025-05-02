{ lib
, buildPythonPackage
, fetchFromGitHub
, h5py
, numpy
, six
, wasserstein
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "energyflow";
  version = "1.3.3";

  src = fetchFromGitHub {
    owner = "pkomiske";
    repo = "EnergyFlow";
    rev = "refs/tags/v${version}";
    hash = "sha256-Ioyk0IpyxcDdL2+3zkUa6yydavyphoh4do7GCz5nG60=";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "setup_requires=" "" \
      --replace "pytest-runner" ""
  '';

  propagatedBuildInputs = [
    h5py
    numpy
    six
    wasserstein
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];
  pytestFlagsArray = [
    "energyflow/tests"
  ];
  disabledTestPaths = [
    "energyflow/tests/test_archs.py" # requires tensorflow
    "energyflow/tests/test_emd.py" # requires "ot"
  ];

  pythonImportsCheck = [ "energyflow" ];

  meta = with lib; {
    description = "Python package for the EnergyFlow suite of tools";
    homepage = "https://energyflow.network/";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ veprbl ];
  };
}
