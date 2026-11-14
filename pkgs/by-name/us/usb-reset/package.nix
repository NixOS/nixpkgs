{
  lib,
  stdenv,
  fetchFromGitHub,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "usb-reset";
  # not tagged, but changelog has this with the date of the e9a9d6c commit
  # and no significant change occurred between bumping the version in the Makefile and that
  # and the changes since then (up to ff822d8) seem snap related
  version = "0.3";

  src = fetchFromGitHub {
    owner = "ralight";
    repo = "usb-reset";
    rev = "e9a9d6c4a533430e763e111a349efbba69e7a5bb";
    hash = "sha256-GlRkL5ozRvmPcdSLk4oQ1ZYnkPJ8kz+2Zc8AETGsOE0=";
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

  meta = {
    broken = stdenv.hostPlatform.isDarwin;
    description = "Perform a bus reset on a USB device using its vendor and product ID";
    homepage = "https://github.com/ralight/usb-reset";
    changelog = "https://github.com/ralight/usb-reset/blob/master/ChangeLog.txt";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
    mainProgram = "usb-reset";
  };
}
