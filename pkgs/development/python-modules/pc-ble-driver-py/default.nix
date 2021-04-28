{ lib, fetchFromGitHub, cmake, git, swig, boost, udev, pc-ble-driver, pythonOlder
, buildPythonPackage, enum34, wrapt, future, setuptools, scikit-build, pythonAtLeast }:

buildPythonPackage rec {
  pname = "pc-ble-driver-py";
  version = "0.15.0";
  disabled = pythonOlder "3.6" || pythonAtLeast "3.9";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-ble-driver-py";
    rev = version;
    sha256 = "1ckbsq9dwca8hpx9frf9xd80b4z4kn9j7jx94hza9bwzrh26x5ji";
  };

  # doCheck tries to write to the global python directory to install things
  doCheck = false;

  nativeBuildInputs = [ cmake swig git setuptools scikit-build ];
  buildInputs = [ boost pc-ble-driver ];
  propagatedBuildInputs = [ enum34 wrapt future ];

  dontUseCmakeConfigure = true;

  meta = with lib; {
    description = "Bluetooth Low Energy nRF5 SoftDevice serialization";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver-py";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
