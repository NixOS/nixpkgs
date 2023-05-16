{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pylint
, pytest
, pytestCheckHook
, pythonOlder
=======
, isPy27
, pytest
, pylint
, six
, pytest-runner
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, toml
}:

buildPythonPackage rec {
  pname = "pytest-pylint";
  version = "0.19.0";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";
=======
  disabled = isPy27;
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2I6DwQI8ZBVIqew1Z3B87udhZjKphq8TNCbUp00GaTI=";
  };

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" ""
  '';

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    pylint
    toml
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "pytest_pylint"
  ];

  meta = with lib; {
    description = "Pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
  nativeBuildInputs = [ pytest-runner ];

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pylint
    six
    toml
  ];

  # tests not included with release
  doCheck = false;

  meta = with lib; {
    description = "pytest plugin to check source code with pylint";
    homepage = "https://github.com/carsongee/pytest-pylint";
    license = licenses.mit;
    maintainers = [ maintainers.costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
