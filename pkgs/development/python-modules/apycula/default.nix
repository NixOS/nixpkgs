{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools-scm
, numpy
, pandas
, pillow
, crcmod
, openpyxl
}:

buildPythonPackage rec {
  pname = "apycula";
<<<<<<< HEAD
  version = "0.8.3";
=======
  version = "0.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Apycula";
<<<<<<< HEAD
    hash = "sha256-QGBWNWAEe6KbfYIoW3FScEL7b4TTcK1YZQoNkfxDNMo=";
=======
    hash = "sha256-IUyhqOuftx06+dvN9afad10IpaefHoUeMwFyTzgBvOQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    numpy
    pandas
    pillow
    crcmod
    openpyxl
  ];

  # tests require a physical FPGA
  doCheck = false;

  pythonImportsCheck = [
    "apycula"
  ];

  meta = with lib; {
    description = "Open Source tools for Gowin FPGAs";
    homepage = "https://github.com/YosysHQ/apicula";
<<<<<<< HEAD
    changelog = "https://github.com/YosysHQ/apicula/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ newam ];
  };
}
