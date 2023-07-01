{ lib
, buildPythonPackage
, fetchPypi
, imgaug
, numpy
, opencv4
, pyyaml
, qudida
, scikit-image
, scipy
, pytestCheckHook
, pythonRelaxDepsHook
}:

buildPythonPackage rec {
  pname = "albumentations";
  version = "1.3.1";
  format = "setuptools";

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

  passthru.optional-dependencies = {
    imgaug = [
      imgaug
    ];
  };

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
    homepage = "https://pypi.org/project/albumentations/";
    license = licenses.mit;
    maintainers = with maintainers; [ natsukium ];
  };
}
