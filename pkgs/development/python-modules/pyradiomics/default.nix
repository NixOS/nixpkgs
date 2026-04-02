{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  numpy,
  pykwalify,
  pywavelets,
  setuptools,
  simpleitk,
  six,
  versioneer,
}:

buildPythonPackage rec {
  pname = "pyradiomics";
  version = "3.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "AIM-Harvard";
    repo = "pyradiomics";
    tag = "v${version}";
    hash = "sha256-/qFNN63Bbq4DUZDPmwUGj1z5pY3ujsbqFJpVXbO+b8E=";
    name = "pyradiomics";
  };

  nativeBuildInputs = [
    setuptools
    versioneer
  ];

  propagatedBuildInputs = [
    numpy
    pykwalify
    pywavelets
    simpleitk
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''
    rm -rf radiomics
  '';
  # tries to access network at collection time:
  disabledTestPaths = [ "tests/test_wavelet.py" ];
  # various urllib download errors and (probably related) missing feature errors:
  disabledTests = [
    "brain1_shape2D-original_shape2D"
    "brain2_shape2D-original_shape2D"
    "breast1_shape2D-original_shape2D"
    "lung1_shape2D-original_shape2D"
    "lung2_shape2D-original_shape2D"
  ];

  pythonImportsCheck = [ "radiomics" ];

  meta = {
    homepage = "https://pyradiomics.readthedocs.io";
    description = "Extraction of Radiomics features from 2D and 3D images and binary masks";
    mainProgram = "pyradiomics";
    changelog = "https://github.com/AIM-Harvard/pyradiomics/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
