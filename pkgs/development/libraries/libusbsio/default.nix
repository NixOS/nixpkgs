{ lib
, stdenv
, fetchzip
, pkg-config
, fixDarwinDylibNames
, libusb1
, systemdMinimal
, darwin
}:

stdenv.mkDerivation rec {
  pname = "libusbsio";
  version = "2.1.11";

  src = fetchzip {
    url = "https://www.nxp.com/downloads/en/libraries/libusbsio-${version}-src.zip";
    sha256 = "sha256-qgoeaGWTWdTk5XpJwoauckEQlqB9lp5x2+TN09vQttI=";
  };

  postPatch = ''
    rm -r bin/*
  '';

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
    "BINDIR="
  ];

  nativeBuildInputs = [
    pkg-config
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    libusb1
  ] ++ lib.optionals stdenv.hostPlatform.isDarwin (with darwin.apple_sdk.frameworks; [
    AppKit
    CoreFoundation
    IOKit
  ]) ++ lib.optionals stdenv.hostPlatform.isLinux [
    systemdMinimal # libudev
  ];

  installPhase = ''
    runHook preInstall
    install -D bin/libusbsio${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libusbsio${stdenv.hostPlatform.extensions.sharedLibrary}
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.nxp.com/design/software/development-software/library-for-windows-macos-and-ubuntu-linux:LIBUSBSIO";
    description = "Library for communicating with devices connected via the USB bridge on LPC-Link2 and MCU-Link debug probes on supported NXP microcontroller evaluation boards";
    platforms = platforms.all;
    license = licenses.bsd3;
    maintainers = with maintainers; [ frogamic sbruder ];
  };
}
