{ lib, stdenv, fetchFromGitHub, cmake, libopenblt }:

stdenv.mkDerivation rec {
  pname = "bootcommander";
  version = "011500";

  src = fetchFromGitHub {
    owner = "feaser";
    repo = "openblt";
    rev = "openblt_v${version}";
    sparseCheckout = [ "Host/Source/" ];
    sha256 = "sha256-cWdc6Imd6IBqYQRNEafp3bDDQLgdpE90fxSkY+vzhAM=";
  };

  preConfigure = "cd ./Host/Source/BootCommander/";

  installPhase = ''
    install -D $NIX_BUILD_TOP/source/Host/BootCommander $out/bin/BootCommander
  '';

  buildInputs = [ libopenblt ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "CLI program to performe firmware updates on microcontrollers that run the OpenBLT bootloader";
    homepage = "https://www.feaser.com/openblt/doku.php?id=manual:bootcommander";
    license = licenses.gpl3;
    maintainers = with maintainers; [ simoneruffini ];
    platforms = platforms.linux;
  };
}
