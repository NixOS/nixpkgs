{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, cmake
<<<<<<< HEAD
, ninja
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, numpy
, pybind11
, scikit-build-core
, typing-extensions
}:

buildPythonPackage rec {
  pname = "awkward-cpp";
<<<<<<< HEAD
  version = "22";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IWeWNvshz+NxX4ijIyaleRmThNstpKYplcMQUC1/6F8=";
=======
  version = "9";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2xyRwh+IuJo5tGF27cZ6CLN/coPBai7VFZ48h0YTxho=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    cmake
<<<<<<< HEAD
    ninja
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pybind11
    scikit-build-core
  ] ++ scikit-build-core.optional-dependencies.pyproject;

  propagatedBuildInputs = [
    numpy
  ];

  dontUseCmakeConfigure = true;

  pythonImportsCheck = [
    "awkward_cpp"
  ];

  meta = with lib; {
    description = "CPU kernels and compiled extensions for Awkward Array";
    homepage = "https://github.com/scikit-hep/awkward";
    license = licenses.bsd3;
    maintainers = with maintainers; [ veprbl ];
  };
}
