{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libusb1
, udev
, Cocoa
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "hidapi";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "${pname}-${version}";
    sha256 = "sha256-XMFG/WeASccb/ClrOyUA/ubgdL4X098tKskOV30h8C4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = lib.optionals stdenv.isLinux [ libusb1 udev ];

  enableParallelBuilding = true;

  propagatedBuildInputs = lib.optionals stdenv.isDarwin [ Cocoa IOKit ];

  meta = with lib; {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = with maintainers; [ prusnak ];
    # You can choose between GPLv3, BSD or HIDAPI license (even more liberal)
    license = with licenses; [ bsd3 /* or */ gpl3Only ] ;
    platforms = platforms.unix;
  };
}
