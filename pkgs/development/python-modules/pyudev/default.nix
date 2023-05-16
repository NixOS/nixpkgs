{ lib, fetchPypi, buildPythonPackage
, six, udev, pytest, mock, hypothesis, docutils
}:

buildPythonPackage rec {
  pname = "pyudev";
<<<<<<< HEAD
  version = "0.24.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-deVNNyGPWsRbDaHw/ZzF5SajysPvHPrUEM96sziwFHE=";
=======
  version = "0.24.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-sqOv4cmep1H4KWZSVX6sVZh02iobHsBiUXhwbsWjRfM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  postPatch = ''
    substituteInPlace src/pyudev/_ctypeslib/utils.py \
      --replace "find_library(name)" "'${lib.getLib udev}/lib/libudev.so'"
    '';

  nativeCheckInputs = [ pytest mock hypothesis docutils ];
  propagatedBuildInputs = [ six ];

  checkPhase = ''
    py.test
  '';

  # Bunch of failing tests
  # https://github.com/pyudev/pyudev/issues/187
  doCheck = false;

  meta = {
    homepage = "https://pyudev.readthedocs.org/";
    description = "Pure Python libudev binding";
    license = lib.licenses.lgpl21Plus;
  };
}
