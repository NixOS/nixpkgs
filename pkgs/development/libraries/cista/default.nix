{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "cista";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "felixguendling";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-dQOVmKRXfApN0QRx/PmLVzeCGppFJBnNWIOoLbDbrds=";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [ "-DCISTA_INSTALL=ON" ];

  meta = with lib; {
    homepage = "https://cista.rocks";
    description = "A simple, high-performance, zero-copy C++ serialization & reflection library";
    license = licenses.mit;
    maintainers = [];
    platforms = platforms.all;
  };
}
