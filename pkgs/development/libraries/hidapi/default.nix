{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, udev, libusb1
, darwin }:

stdenv.mkDerivation rec {
  pname = "hidapi";
  version = "0.10.1";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "${pname}-${version}";
    sha256 = "1nr4z4b10vpbh3ss525r7spz4i43zim2ba5qzfl15dgdxshxxivb";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config ];

  buildInputs = [ ]
    ++ lib.optionals stdenv.isLinux [ libusb1 udev ];

  enableParallelBuilding = true;

  propagatedBuildInputs = lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit Cocoa ]);

  meta = with lib; {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = with maintainers; [ prusnak ];
    # Actually, you can chose between GPLv3, BSD or HIDAPI license (more liberal)
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
