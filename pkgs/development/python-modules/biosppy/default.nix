{
  lib,
  stdenv,
  bidict,
  buildPythonPackage,
  fetchFromGitHub,
  h5py,
  joblib,
  matplotlib,
  mock,
  numpy,
  opencv-python,
  peakutils,
  pywavelets,
  scikit-learn,
  scipy,
  setuptools,
  shortuuid,
  six,
  tkinter,
}:

buildPythonPackage rec {
  pname = "biosppy";
  version = "2.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scientisst";
    repo = "BioSPPy";
    tag = "v${version}";
    hash = "sha256-R+3K8r+nzrCiZegxur/rf3/gDGhN9bVNMhlK94SHer0=";
  };

  build-system = [ setuptools ];

  dependencies = [
    bidict
    h5py
    joblib
    matplotlib
    mock
    numpy
    opencv-python
    peakutils
    pywavelets
    scikit-learn
    scipy
    shortuuid
    six
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
    changelog = "https://github.com/scientisst/BioSPPy/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ genga898 ];
  };
}
