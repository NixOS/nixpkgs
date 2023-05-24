{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, pytestCheckHook
, numpy
, pykwalify
, pywavelets
, setuptools
, simpleitk
, six
, versioneer
}:

buildPythonPackage rec {
  pname = "pyradiomics";
  version = "3.1.0";
  #format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AIM-Harvard";
    repo = "pyradiomics";
    rev = "refs/tags/v${version}";
    hash = "sha256-/qFNN63Bbq4DUZDPmwUGj1z5pY3ujsbqFJpVXbO+b8E=";
  };

  nativeBuildInputs = [ setuptools versioneer ];

  propagatedBuildInputs = [
    numpy
    pykwalify
    pywavelets
    simpleitk
    six
  ];

  nativeCheckInputs = [ pytestCheckHook ];
  preCheck = ''
    cd tests  # fails to import c extensions when running from source root
    ln -s ../data data
  '';
  doCheck = false; 
  disabledTestPaths = [ "test_wavelet.py" ];

  pythonImportsCheck = [
    "radiomics"
  ];

  meta = with lib; {
    homepage = "http://pyradiomics.readthedocs.io";
    description = "Extraction of Radiomics features from 2D and 3D images and binary masks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
