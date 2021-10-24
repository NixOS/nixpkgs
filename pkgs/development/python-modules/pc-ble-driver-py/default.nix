{ lib
, boost
, buildPythonPackage
, cmake
, cryptography
, fetchFromGitHub
, git
, pc-ble-driver
, pythonAtLeast
, pythonOlder
, scikit-build
, setuptools
, swig
, udev
, wrapt
}:

buildPythonPackage rec {
  pname = "pc-ble-driver-py";
  version = "0.16.1";

  disabled = pythonOlder "3.7" || pythonAtLeast "3.10";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-ble-driver-py";
    rev = "v${version}";
    sha256 = "0q2zag77drcjkjm0cbvy2sf6fq2a4yl5li1zv1xfwmy53ami9b5l";
  };

  nativeBuildInputs = [
    cmake
    swig
    git
    setuptools
    scikit-build
  ];

  buildInputs = [
    boost
    pc-ble-driver
  ];

  propagatedBuildInputs = [
    cryptography
    wrapt
  ];

  dontUseCmakeConfigure = true;

  # doCheck tries to write to the global python directory to install things
  doCheck = false;

  pythonImportsCheck = [
    "pc_ble_driver_py"
  ];

  meta = with lib; {
    description = "Bluetooth Low Energy nRF5 SoftDevice serialization";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver-py";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
