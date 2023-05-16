{ lib
, buildPythonPackage
, cython
, enum34
, fetchPypi
, nine
, numpy
, pytestCheckHook
, python-utils
}:

buildPythonPackage rec {
  pname = "numpy-stl";
<<<<<<< HEAD
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3U2ho3nSYy8WhRi+jc2c3dftxsMjgJT9jSFHazWGoLw=";
=======
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V4t46ssFKayaui8X3MNj1Yx8PFcIcQwY+MHpll8ugaw=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    cython
    enum34
    nine
    numpy
    python-utils
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "stl" ];

  meta = with lib; {
    description = "Library to make reading, writing and modifying both binary and ascii STL files easy";
    homepage = "https://github.com/WoLpH/numpy-stl/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
