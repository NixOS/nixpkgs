{ lib
, buildPythonPackage
, fetchFromGitHub
, imageio
, numpy
, pytestCheckHook
, pythonOlder
, scikitimage
, slicerator
}:

buildPythonPackage rec {
  pname = "pims";
  version = "0.6.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-QdllA1QTSJ8vWaSJ0XoUanX53sb4RaOmdXBCFEsoWMU=";
  };

  propagatedBuildInputs = [
    slicerator
    imageio
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scikitimage
  ];

  pythonImportsCheck = [
    "pims"
  ];

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTests = [
    # NotImplementedError: Do not know how to deal with infinite readers
    "TestVideo_ImageIO"
  ];

  meta = with lib; {
    description = "Python Image Sequence: Load video and sequential images in many formats with a simple, consistent interface";
    homepage = "https://github.com/soft-matter/pims";
    license = licenses.bsd3;
    maintainers = with maintainers; [ costrouc ];
  };
}
