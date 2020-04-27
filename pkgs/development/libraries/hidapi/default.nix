{ stdenv, fetchFromGitHub, autoreconfHook, pkgconfig, systemd, libusb1
, darwin }:

stdenv.mkDerivation rec {
  pname = "hidapi";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "${pname}-${version}";
    sha256 = "1p4g8lgwj4rki6lbn5l6rvwj0xlbn1xfh4d255bg5pvgczmwmc4i";
  };

  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  buildInputs = [ ]
    ++ stdenv.lib.optionals stdenv.isLinux [ libusb1 systemd ];

  enableParallelBuilding = true;

  propagatedBuildInputs = stdenv.lib.optionals stdenv.isDarwin (with darwin.apple_sdk.frameworks; [ IOKit Cocoa ]);

  meta = with stdenv.lib; {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    # Actually, you can chose between GPLv3, BSD or HIDAPI license (more liberal)
    license = licenses.bsd3;
    platforms = platforms.unix;
  };
}
