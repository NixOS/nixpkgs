{ lib
<<<<<<< HEAD
, buildPythonPackage
, fetchPypi
, numpy
, pythonOlder
=======
, fetchPypi
, buildPythonPackage
, pytest-runner
, numpy
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, pyyaml
}:

buildPythonPackage rec {
  pname = "pysrim";
  version = "0.5.10";
<<<<<<< HEAD
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-raCI9z9+GjvwhSBugeD4PticHQsjp4ns0LoKJQckrug=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "'pytest-runner', " ""
  '';

  propagatedBuildInputs = [
    numpy
    pyyaml
  ];
=======

  src = fetchPypi {
    inherit pname version;
    sha256 = "ada088f73f7e1a3bf085206e81e0f83ed89c1d0b23a789ecd0ba0a250724aee8";
  };

  buildInputs = [ pytest-runner ];
  propagatedBuildInputs = [ numpy pyyaml ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Tests require git lfs download of repository
  doCheck = false;

<<<<<<< HEAD
  # pythonImportsCheck does not work
  # TypeError: load() missing 1 required positional argument: 'Loader'

  meta = with lib; {
    description = "Srim Automation of Tasks via Python";
    homepage = "https://gitlab.com/costrouc/pysrim";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
=======
  meta = {
    description = "Srim Automation of Tasks via Python";
    homepage = "https://gitlab.com/costrouc/pysrim";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
