{ lib
, buildPythonPackage
, fetchPypi
, numpy
, opencv4
, pyyaml
, qudida
, scikit-image
, scipy
, pytestCheckHook
, pythonOlder
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pqODiP5UbFaAcejIL0FEmOhsntA8CLWOeoizHPeiRMY=";
  };

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  pythonRemoveDeps = [
    "opencv-python"
  ];

  propagatedBuildInputs = [
    numpy
    opencv4
    pyyaml
    qudida
    scikit-image
    scipy
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = [
    # this test hangs up
    "test_transforms"
  ];

  pythonImportsCheck = [ "albumentations" ];

  meta = with lib; {
    description = "Fast image augmentation library and easy to use wrapper around other libraries";
    homepage = "https://github.com/albumentations-team/albumentations";
    changelog = "https://github.com/albumentations-team/albumentations/releases/tag/${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
