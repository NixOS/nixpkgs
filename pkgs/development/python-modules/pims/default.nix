{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  imageio,
  numpy,
  pytestCheckHook,
  pythonOlder,
  scikit-image,
  slicerator,
}:

buildPythonPackage rec {
  pname = "pims";
  version = "0.7";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "soft-matter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-3SBZk11w6eTZFmETMRJaYncxY38CYne1KzoF5oRgzuY=";
  };

  propagatedBuildInputs = [
    slicerator
    imageio
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scikit-image
  ];

  pythonImportsCheck = [ "pims" ];

  pytestFlagsArray = [
    "-W"
    "ignore::Warning"
  ];

  disabledTests = [
    # NotImplementedError: Do not know how to deal with infinite readers
    "TestVideo_ImageIO"
  ];

  disabledTestPaths = [
    # AssertionError: Tuples differ: (377, 505, 4) != (384, 512, 4)
    "pims/tests/test_display.py"
  ];

  meta = with lib; {
    description = "Module to load video and sequential images in various formats";
    homepage = "https://github.com/soft-matter/pims";
    changelog = "https://github.com/soft-matter/pims/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
