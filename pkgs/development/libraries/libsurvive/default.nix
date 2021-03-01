{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, freeglut
, liblapack
, libusb1
, openblas
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libsurvive";
  version = "0.3";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = pname;
    rev = "v${version}";
    sha256 = "0m21fnq8pfw2pcvqfgjws531zmalda423q9i65v4qzm8sdb54hl4";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    freeglut
    liblapack
    libusb1
    openblas
    zlib
  ];

  meta = with lib; {
    description = "Open Source Lighthouse Tracking System";
    homepage = "https://github.com/cntools/libsurvive";
    license = licenses.mit;
    maintainers = with maintainers; [ expipiplus1 prusnak ];
    platforms = platforms.linux;
  };
}
