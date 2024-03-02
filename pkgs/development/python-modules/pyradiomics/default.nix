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
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "AIM-Harvard";
    repo = "pyradiomics";
    rev = "refs/tags/v${version}";
    hash = "sha256-/qFNN63Bbq4DUZDPmwUGj1z5pY3ujsbqFJpVXbO+b8E=";
    name = "pyradiomics";
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
  # note the above elements of disabledTests are patterns, not exact tests,
  # so simply setting `disabledTests` does not suffice:
  pytestFlagsArray = [
    "-k '${toString (lib.intersperse "and" (lib.forEach disabledTests (t: "not ${t}")))}'"
  ];

  pythonImportsCheck = [
    "radiomics"
  ];

  meta = with lib; {
    homepage = "https://pyradiomics.readthedocs.io";
    description = "Extraction of Radiomics features from 2D and 3D images and binary masks";
    changelog = "https://github.com/AIM-Harvard/pyradiomics/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
