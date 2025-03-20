{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  udev,
  Cocoa,
  IOKit,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hidapi";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "libusb";
    repo = "hidapi";
    rev = "hidapi-${finalAttrs.version}";
    sha256 = "sha256-p3uzBq5VxxQbVuy1lEHEEQdxXwnhQgJDIyAAWjVWNIg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    libusb1
    udev
  ];

  enableParallelBuilding = true;

  propagatedBuildInputs = lib.optionals stdenv.hostPlatform.isDarwin [
    Cocoa
    IOKit
  ];

  passthru.tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;

  meta = with lib; {
    description = "Library for communicating with USB and Bluetooth HID devices";
    homepage = "https://github.com/libusb/hidapi";
    maintainers = with maintainers; [ prusnak ];
    # You can choose between GPLv3, BSD or HIDAPI license (even more liberal)
    license = with licenses; [
      bsd3 # or
      gpl3Only
    ];
    pkgConfigModules =
      lib.optionals stdenv.hostPlatform.isDarwin [
        "hidapi"
      ]
      ++ lib.optionals stdenv.hostPlatform.isLinux [
        "hidapi-hidraw"
        "hidapi-libusb"
      ];
    platforms = platforms.unix ++ platforms.windows;
  };
})
