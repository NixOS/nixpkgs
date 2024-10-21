{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xlink-luxonis";
  version = "2020.2";

  src = fetchFromGitHub {
    owner = "luxonis";
    repo = "xlink";
    rev = "refs/tags/luxonis-${finalAttrs.version}";
    hash = "sha256-3jP0Z23M78xyY3CVMYtg5D96klZp0stae850SPqqmdE=";
  };

  # Patches adapted from https://github.com/luxonis/depthai-core/issues/447#issuecomment-1164015416
  patches = [ ./0001-allow-setting-libusb-paths.patch ];

  postPatch = ''
    sed -i "s|@LIBUSB_INCLUDE_DIR@|${libusb1.dev}/include/libusb-1.0|" XLink.cmake
    sed -i "s|@LIBUSB_LIBRARY@|${libusb1}/lib/libusb-1.0.so|" XLink.cmake
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libusb1
  ];

  cmakeFlags = [
    (lib.cmakeBool "HUNTER_ENABLED" false)
    (lib.cmakeBool "XLINK_LIBUSB_SYSTEM" true)
  ];

  meta = {
    description = "A cross-platform library for communicating with devices over various physical links [Luxonis fork]";
    homepage = "https://github.com/luxonis/XLink";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 tmayoff ];
  };
})
