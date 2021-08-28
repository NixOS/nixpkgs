{ lib, stdenv, fetchFromGitHub, boost, cmake, curl, ruby }:

stdenv.mkDerivation rec {
  pname = "leatherman";
  version = "1.12.4";

  src = fetchFromGitHub {
    sha256 = "sha256-7e9D9Q3CAm+2+0vl81djSZwKrQRXc5UxcbJVMt91/vU=";
    rev = version;
    repo = "leatherman";
    owner = "puppetlabs";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost curl ruby ];

  meta = with lib; {
    homepage = "https://github.com/puppetlabs/leatherman/";
    description = "A collection of C++ and CMake utility libraries";
    license = licenses.asl20;
    maintainers = [ maintainers.womfoo ];
    platforms = platforms.unix;
  };

}
