{ lib, stdenv, fetchFromGitHub, libusb-compat-0_1, readline, cmake, pkg-config }:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = pname;
    rev = "libnfc-${version}";
    sha256 = "5gMv/HajPrUL/vkegEqHgN2d6Yzf01dTMrx4l34KMrQ=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libusb-compat-0_1 readline ];

  configureFlags = [ "sysconfdir=/etc" ];

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Open source library libnfc for Near Field Communication";
    license = licenses.gpl3;
    homepage = "https://github.com/nfc-tools/libnfc";
    maintainers = with maintainers; [ offline ];
    platforms = platforms.unix;
  };
}
