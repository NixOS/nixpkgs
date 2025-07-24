{
  lib,
  stdenv,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  bidict,
  h5py,
  matplotlib,
  numpy,
  scikit-learn,
  scipy,
  shortuuid,
  six,
  joblib,
  pywavelets,
  mock,
  tkinter,
  opencv-python,
}:

buildPythonPackage rec {
  pname = "biosppy";
  version = "2.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scientisst";
    repo = "BioSPPy";
    tag = "v${version}";
    hash = "sha256-U0ZftAlRlazSO66raH74o/6eP1RpmuFoA6HJ+xmgKR8=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    opencv-python
    bidict
    h5py
    matplotlib
    numpy
    scikit-learn
    scipy
    shortuuid
    six
    joblib
    pywavelets
    mock
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ tkinter ];

  doCheck = false; # no tests

  pythonImportsCheck = [
    "biosppy"
    "biosppy.signals"
    "biosppy.synthesizers"
    "biosppy.inter_plotting"
    "biosppy.features"
  ];

  meta = {
    description = "Biosignal Processing in Python";
    homepage = "https://biosppy.readthedocs.io/";
    changelog = "https://github.com/scientisst/BioSPPy/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
