{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, hidapi
, libusb1
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libnitrokey";
  version = "3.8";

  src = fetchFromGitHub {
    owner = "Nitrokey";
    repo = "libnitrokey";
    rev = "v${finalAttrs.version}";
    hash = "sha256-9ZMR1g04gNzslax6NpD6KykfUfjpKFIizaMMn06iJa0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  cmakeFlags = [
    "-DADD_GIT_INFO=OFF"
    "-DCMAKE_INSTALL_UDEVRULESDIR=etc/udev/rules.d"
  ];

  buildInputs = [ libusb1 ];

  propagatedBuildInputs = [ hidapi ];

  meta = with lib; {
    description = "Communicate with Nitrokey devices in a clean and easy manner";
    homepage = "https://github.com/Nitrokey/libnitrokey";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ panicgh raitobezarius ];
  };
})
