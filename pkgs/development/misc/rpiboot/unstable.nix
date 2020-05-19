{ stdenv, fetchFromGitHub, libusb1 }:

let
  version = "2020-02-17";
  name = "rpiboot-unstable-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "7ef900578a2c410062cfc93c439157aec0ef9f5c";
    sha256 = "095fvdiijhi1wl650ssw2bqcxnhpvhldppx8fir5c8h6qjkh1f1i";
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
    description = "Utility to boot a Raspberry Pi 4/CM/CM3/Zero over USB";
    maintainers = [ stdenv.lib.maintainers.cartr ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
