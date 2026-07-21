{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
  matplotlib,
  pytestCheckHook,
}:

buildPythonPackage {
  pname = "regional";
  version = "1.1.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "freeman-lab";
    repo = "regional";
    rev = "e3a29c58982e5cd3d5700131ac96e5e0b84fb981"; # no tags in repo
    hash = "sha256-u88v9H9RZ9cgtSat73QEnHr3gZGL8DmBZ0XphMuoDw8=";
  };

  propagatedBuildInputs = [
    matplotlib
    numpy
    scipy
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "regional" ];

  disabledTests = [
    "test_dilate"
    "test_outline"
    "test_mask"
  ];

  meta = {
    description = "Simple manipualtion and display of spatial regions";
    homepage = "https://github.com/freeman-lab/regional";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
