{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
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
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AIM-Harvard";
    repo = "pyradiomics";
    tag = "v${version}";
    hash = "sha256-xyFRccogBwry/apTOMVVa0JDoaSydWqT5KfzSGYyr1Q=";
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
