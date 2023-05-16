{ lib
, buildPythonPackage
<<<<<<< HEAD
, fetchFromGitHub
, numpy
, scipy
, matplotlib
, pytestCheckHook
, isPy3k
}:

buildPythonPackage {
  pname = "filterpy";
  version = "unstable-2022-08-23";
  format = "setuptools";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "rlabbe";
    repo = "filterpy";
    rev = "3b51149ebcff0401ff1e10bf08ffca7b6bbc4a33";
    hash = "sha256-KuuVu0tqrmQuNKYmDmdy+TU6BnnhDxh4G8n9BGzjGag=";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    numpy
    scipy
    matplotlib
  ];
=======
, fetchPypi
, numpy
, scipy
, matplotlib
, pytest
, isPy3k
}:

buildPythonPackage rec {
  version = "1.4.5";
  pname = "filterpy";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    extension = "zip";
    sha256 = "4f2a4d39e4ea601b9ab42b2db08b5918a9538c168cff1c6895ae26646f3d73b1";
  };

  nativeCheckInputs = [ pytest ];
  propagatedBuildInputs = [ numpy scipy matplotlib ];

  # single test fails (even on master branch of repository)
  # project does not use CI
  checkPhase = ''
    pytest --ignore=filterpy/common/tests/test_discretization.py
  '';
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    homepage = "https://github.com/rlabbe/filterpy";
    description = "Kalman filtering and optimal estimation library";
    license = licenses.mit;
<<<<<<< HEAD
    maintainers = [ ];
=======
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
