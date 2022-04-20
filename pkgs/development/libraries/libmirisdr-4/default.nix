{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, libusb1
} :

stdenv.mkDerivation rec {
  pname = "libmirisdr-4";
  version = "1.1.2";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "${pname}";
    rev = "v${version}";
    sha256 = "sha256-woqWZOlmPmye5fSANCns7KTLTnxNB3nH/v95sCXO1F4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ libusb1 ];

  cmakeFlags = [
    "-DDETACH_KERNEL_DRIVER=ON"
  ];

  meta = with lib; {
    description = "Mirics MSi001 + MSi2500 SDR device library";
    homepage = "https://github.com/f4exb/libmirisdr-4";
    license = licenses.gpl2;
    maintainers = with maintainers; [ alexwinter ];
    platforms = platforms.linux;
  };
}
