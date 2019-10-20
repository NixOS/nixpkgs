{ stdenv, fetchFromGitHub
, cmake, pkgconfig
, libusb, pcsclite, acsccid }:

stdenv.mkDerivation rec {
  pname = "libnfc";
  version = "2019-08-21";

  src = fetchFromGitHub {
    owner = "nfc-tools";
    repo = "libnfc";
    rev = "f8b28523d710c2354e1dc9094be5ebbaff494ea3";
    sha256 = "0kpm436cw5f1344fbgni0ak89kk29z2n25d847wd84qxwqpak27q";
  };

  buildInputs = [ libusb pcsclite acsccid ];

  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [
    "-DLIBNFC_DRIVER_ACR122_PCSC=ON"
  ];

  meta = with stdenv.lib; {
    description = "Open source library libnfc for Near Field Communication";
    license = licenses.gpl3;
    homepage = https://github.com/nfc-tools/libnfc;
    maintainers = with maintainers; [offline];
    platforms = platforms.unix;
  };
}
