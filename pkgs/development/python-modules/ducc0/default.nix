{ stdenv, lib, buildPythonPackage, fetchFromGitLab, pythonOlder, pytestCheckHook, pybind11, numpy }:

buildPythonPackage rec {
  pname = "ducc0";
<<<<<<< HEAD
  version = "0.31.0";
=======
  version = "0.30.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  disabled = pythonOlder "3.7";

  src = fetchFromGitLab {
    domain = "gitlab.mpcdf.mpg.de";
    owner = "mtr";
    repo = "ducc";
    rev = "ducc0_${lib.replaceStrings ["."] ["_"] version}";
<<<<<<< HEAD
    hash = "sha256-4aNIq5RNo1Qqiqr2wjYB/FXKyvbARsRF1yW1ZzZlAOo=";
=======
    hash = "sha256-xYjgJGtWl9AjnzlFvdj/0chnIUDmoH85AtKXsNBwWUU=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  buildInputs = [ pybind11 ];
  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "python/test" ];
  pythonImportsCheck = [ "ducc0" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    homepage = "https://gitlab.mpcdf.mpg.de/mtr/ducc";
    description = "Efficient algorithms for Fast Fourier transforms and more";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ parras ];
  };
}
