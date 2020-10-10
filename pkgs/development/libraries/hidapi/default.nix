{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, udev, libusb1
, darwin }:

stdenv.mkDerivation rec {
  pname = "hidapi";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "${pname}-${version}";
    sha256 = "1n3xn1zvxgyzb84cjpw3i5alw0gkbrps11r4ijxzyqxqym0khagr";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libusb1 udev ];

  enableParallelBuilding = true;

  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit Cocoa ]);

  meta = with stdenv.lib; {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = with maintainers; [ prusnak ];
    # Actually, you can chose between GPLv3, BSD or HIDAPI license (more liberal)
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
