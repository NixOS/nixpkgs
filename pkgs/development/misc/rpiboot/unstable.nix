{ stdenv, fetchFromGitHub, libusb1 }:

let
  version = "2018-03-27";
  name = "rpiboot-unstable-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "usbboot";
    rev = "fb86716935f2e820333b037a2ff93a338ad9b695";
    sha256 = "163g7iw7kf6ra71adx6lf1xzf3kv20bppva15ljwn54jlah5mv98";
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
    homepage = https://github.com/raspberrypi/usbboot;
    description = "Utility to boot a Raspberry Pi CM/CM3/Zero over USB";
    maintainers = [ stdenv.lib.maintainers.cartr ];
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
