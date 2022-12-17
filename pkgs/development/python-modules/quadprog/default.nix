{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, cython
, numpy
, pytestCheckHook
, scipy
}:

buildPythonPackage rec {
  pname = "quadprog";
  version = "0.1.11";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/suv1KbG3HbiYqEiuCtB/ia3xbxAO5AMuWx1Svy0rMw=";
  };

  nativeBuildInputs = [
    cython
  ];

  propagatedBuildInputs = [
    numpy
  ];

  preBuild = ''
    cython quadprog/quadprog.pyx
  '';

  checkInputs = [
    pytestCheckHook
    scipy
  ];

  pytestFlagsArray = [
    # test fails on aarch64-darwin
    "--deselect=tests/test_1.py::test_5"
  ];

  meta = with lib; {
    homepage = "https://github.com/quadprog/quadprog";
    changelog = "https://github.com/quadprog/quadprog/releases/tag/v${version}";
    description = "Quadratic Programming Solver";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
  };
}
