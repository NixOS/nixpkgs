{ lib
, buildPythonPackage
, fetchPypi
, python
, six
, pythonOlder
, coverage
}:

buildPythonPackage rec {
  pname = "nose2";
  version = "0.12.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lW55ub1VjuCLYgDAWtLHZGW344YMDAU3aGCJKFwyARM=";
  };

  propagatedBuildInputs = [
    coverage
    six
  ];

<<<<<<< HEAD
  __darwinAllowLocalNetworking = true;

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  checkPhase = ''
    ${python.interpreter} -m unittest
  '';

  pythonImportsCheck = [
    "nose2"
  ];

  meta = with lib; {
    description = "Test runner for Python";
    homepage = "https://github.com/nose-devs/nose2";
    license = licenses.bsd0;
    maintainers = with maintainers; [ ];
  };
}
