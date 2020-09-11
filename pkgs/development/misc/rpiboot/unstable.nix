{ stdenv, fetchFromGitHub, libusb1 }:

let
  version = "2020-05-11";
  name = "rpiboot-unstable-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "c650cd747c1d0597487dcf319bf95b5ba775d78b";
    sha256 = "17kapny79dh05vfmrniqdvz6xhpwnqnw0511ycfx4qcjh4krxh8n";
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

  meta = {
    homepage = "https://github.com/raspberrypi/usbboot";
    description = "Utility to boot a Raspberry Pi CM/CM3/Zero over USB";
    maintainers = [ stdenv.lib.maintainers.cartr ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
