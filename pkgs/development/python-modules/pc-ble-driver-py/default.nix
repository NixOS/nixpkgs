{ stdenv, fetchFromGitHub, cmake, git, swig, boost, udev, pc-ble-driver
, buildPythonPackage, enum34, wrapt, future, setuptools, scikit-build }:

buildPythonPackage rec {
  pname = "pc-ble-driver-py";
  version = "0.14.2";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-ble-driver-py";
    rev = "v${version}";
    sha256 = "1zbi3v4jmgq1a3ml34dq48y1hinw2008vwqn30l09r5vqvdgnj8m";
  };

  # doCheck tries to write to the global python directory to install things
  doCheck = false;

  nativeBuildInputs = [ cmake swig git setuptools scikit-build ];
  buildInputs = [ boost pc-ble-driver ];
  propagatedBuildInputs = [ enum34 wrapt future ];

  dontUseCmakeConfigure = true;

  meta = with stdenv.lib; {
    description = "Bluetooth Low Energy nRF5 SoftDevice serialization";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver-py";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ gebner ];
  };
}
