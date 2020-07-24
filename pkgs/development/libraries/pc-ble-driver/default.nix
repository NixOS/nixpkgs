{ stdenv, fetchFromGitHub, git, cmake, catch2, asio, udev, IOKit }:

stdenv.mkDerivation rec {
  pname = "pc-ble-driver";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "NordicSemiconductor";
    repo = "pc-ble-driver";
    rev = "v${version}";
    sha256 = "1llhkpbdbsq9d91m873vc96bprkgpb5wsm5fgs1qhzdikdhg077q";
  };

  cmakeFlags = [
    "-DNRF_BLE_DRIVER_VERSION=${version}"
  ];

  nativeBuildInputs = [ cmake git ];
  buildInputs = [ catch2 asio ];

  propagatedBuildInputs = [

  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    IOKit
  ] ++ stdenv.lib.optionals stdenv.isLinux [
    udev
  ];

  meta = with stdenv.lib; {
    description = "Desktop library for Bluetooth low energy development";
    homepage = "https://github.com/NordicSemiconductor/pc-ble-driver";
    license = licenses.unfreeRedistributable;
    platforms = platforms.unix;
    maintainers = with maintainers; [ jschievink ];
  };
}
