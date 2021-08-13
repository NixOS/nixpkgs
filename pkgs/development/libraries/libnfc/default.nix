{ lib, stdenv, fetchurl, libusb-compat-0_1, readline }:
let
  version = "1.8.0";
in
stdenv.mkDerivation {
  inherit version;
  pname = "libnfc"

  src = fetchurl {
    url = "https://github.com/nfc-tools/libnfc/releases/download/libnfc-${version}/libnfc-${version}.tar.bz2";
    sha256 = "1m9xpbza648ngn8xiq62hdv4kiq1669v218glvq131s0hqfd76kd";
  };

  buildInputs = [ libusb-compat-0_1 readline ];

  meta = with lib; {
    description = "Open source library libnfc for Near Field Communication";
    license = licenses.gpl3;
    homepage = "https://github.com/nfc-tools/libnfc";
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
