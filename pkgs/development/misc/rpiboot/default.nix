{ lib, stdenv, fetchFromGitHub, libusb1, pkg-config }:

stdenv.mkDerivation rec {
  pname = "rpiboot";
  version = "20221215-105525";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = version;
    hash = "sha256-Y77IrDblXmnpZleJ3zTyiGDYLZ7gNxASXpqUzwS1NCU=";
  };

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ pkg-config ];

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
    mainProgram = "rpiboot";
    license = licenses.asl20;
    maintainers = with maintainers; [ cartr flokli ];
    platforms = [ "aarch64-linux" "aarch64-darwin" "armv7l-linux" "armv6l-linux" "x86_64-linux" "x86_64-darwin" ];
  };
}
