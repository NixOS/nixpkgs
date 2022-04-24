{ lib, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, freeglut
, lapack
, libusb1
, blas
, zlib
}:

stdenv.mkDerivation rec {
  pname = "libsurvive";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "cntools";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-atX7QsCjKGa6OVSApnx3seBvZv/mlpV3jWRB9+v7Emc=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    freeglut
    lapack
    libusb1
    blas
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
