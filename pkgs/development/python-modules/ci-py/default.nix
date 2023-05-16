<<<<<<< HEAD
{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ci-py";
  version = "1.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-R/6bLsXOKGxiJDZUvvOuvLp3usEhfg698qvvgOwBXYk=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "ci"
  ];
=======
{ lib, buildPythonPackage, fetchPypi, isPy27
, pytest, pytest-runner, pytestCheckHook }:

buildPythonPackage rec {
  version = "1.0.0";
  pname = "ci-py";

  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "12ax07n81vxbyayhwzi1q6x7gfmwmvrvwm1n4ii6qa6fqlp9pzj7";
  };

  nativeBuildInputs = [ pytest-runner ];  # pytest-runner included in setup-requires
  nativeCheckInputs = [ pytest pytestCheckHook ];

  pythonImportsCheck = [ "ci" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = with lib; {
    description = "Library for working with Continuous Integration services";
    homepage = "https://github.com/grantmcconnaughey/ci.py";
<<<<<<< HEAD
    changelog = "https://github.com/grantmcconnaughey/ci.py/blob/master/CHANGELOG.md";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ bcdarwin ];
  };
}
