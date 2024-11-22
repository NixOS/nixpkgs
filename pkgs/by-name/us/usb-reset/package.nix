{ lib
, stdenv
, fetchFromGitHub
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "usb-reset";
  # not tagged, but changelog has this with the date of the e9a9d6c commit
  # and no significant change occured between bumping the version in the Makefile and that
  # and the changes since then (up to ff822d8) seem snap related
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ralight";
    repo = pname;
    rev = "e9a9d6c4a533430e763e111a349efbba69e7a5bb";
    sha256 = "0k9qmhqi206gcnv3z4vwya82g5nm225972ylf67zjiikk8pn8m0s";
  };

  buildInputs = [ libusb1 ];

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/include/libusb-1.0 ${libusb1.dev}/include/libusb-1.0
  '';

  makeFlags = [
    "DESTDIR=${placeholder "out"}"
    "prefix="
  ];

  meta = with lib; {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Perform a bus reset on a USB device using its vendor and product ID";
    homepage = "https://github.com/ralight/usb-reset";
    changelog = "https://github.com/ralight/usb-reset/blob/master/ChangeLog.txt";
    license = licenses.mit;
    maintainers = [ maintainers.evils ];
    platforms = platforms.all;
    mainProgram = "usb-reset";
  };
}
