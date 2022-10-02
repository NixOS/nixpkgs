{ lib, stdenv, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation rec {
  pname = "rpiboot";
  version = "2021.07.01";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "v${version}";
    sha256 = "sha256-BkNyYCrasfiRs7CbJa7tCo2k70TLGcXkOX+zGPyZGGE=";
  };

  nativeBuildInputs = [ libusb1 ];

  patchPhase = ''
    sed -i "s@/usr/@$out/@g" main.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/rpiboot
    cp rpiboot $out/bin
    cp -r msd $out/share/rpiboot
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/usbboot";
    description = "Utility to boot a Raspberry Pi CM/CM3/CM4/Zero over USB";
    license = licenses.asl20;
    maintainers = with maintainers; [ cartr ];
    platforms = [ "aarch64-linux" "aarch64-darwin" "armv7l-linux" "armv6l-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
