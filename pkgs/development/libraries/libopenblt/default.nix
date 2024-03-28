{ lib, stdenv, fetchFromGitHub, cmake, libusb1 }:

stdenv.mkDerivation rec {

  pname = "libopenblt";
  version = "011500";

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "openblt_v${version}";
    sparseCheckout = [ "Host/Source/" ];
    sha256 = "sha256-cWdc6Imd6IBqYQRNEafp3bDDQLgdpE90fxSkY+vzhAM=";
  };

  preConfigure = "cd ./Host/Source/LibOpenBLT/";

  installPhase = ''
    install -D $NIX_BUILD_TOP/source/Host/libopenblt.so $out/lib/libopenblt.so
    install -D $NIX_BUILD_TOP/source/Host/Source/LibOpenBLT/openblt.h $out/include/openblt.h
  '';

  buildInputs = [ libusb1 ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "API for communicating with a microcontrollers running the OpenBLT bootloader";
    homepage = "https://www.feaser.com/openblt/doku.php?id=manual:libopenblt";
    license = licenses.gpl3;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
  };
}
