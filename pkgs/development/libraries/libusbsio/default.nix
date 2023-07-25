{ lib, stdenv, fetchzip, pkg-config, libusb1, systemdMinimal }:
let
  binDirPrefix = if stdenv.isDarwin then "osx_" else "linux_";
in
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

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libusb1
    systemdMinimal # libudev
  ];

  installPhase = ''
    runHook preInstall
    install -D bin/${binDirPrefix}${stdenv.hostPlatform.parsed.cpu.name}/libusbsio${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/libusbsio${stdenv.hostPlatform.extensions.sharedLibrary}
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
