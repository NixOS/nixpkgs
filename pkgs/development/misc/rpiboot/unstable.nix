{ lib, stdenv, fetchFromGitHub, libusb1 }:

stdenv.mkDerivation {
  pname = "rpiboot";
  version = "unstable-2020-10-20";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "d3760e119385a179765f43a50a8e051a44127c25";
    sha256 = "0vygzh2h27xplqp1x4isj6kgrgmvmvc1mr3ghmsi98kzp91w772r";
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
    description = "Utility to boot a Raspberry Pi CM/CM3/Zero over USB";
    license = licenses.asl20;
    maintainers = with maintainers; [ cartr ];
    platforms = [ "aarch64-linux" "armv7l-linux" "armv6l-linux" "x86_64-linux" ];
  };
}
