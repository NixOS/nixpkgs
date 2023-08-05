{ lib
, stdenv
, fetchFromGitHub
, argtable
, cmake
, libserialport
, pkg-config
, IOKit
}:

stdenv.mkDerivation {
  pname = "blisp";
  version = "unstable-2023-06-03";

  src = fetchFromGitHub {
    owner = "pine64";
    repo = "blisp";
    rev = "048a72408218788d519a87bcdfb23bcf9ed91a84";
    hash = "sha256-hipJrr0D4uEN2hk8ooXeg0gv0X3w4U9ReXbC4oPEPwI=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    argtable
    libserialport
  ] ++ lib.optional stdenv.isDarwin IOKit;

  cmakeFlags = [
    "-DBLISP_BUILD_CLI=ON"
    "-DBLISP_USE_SYSTEM_LIBRARIES=ON"
  ];

  meta = with lib; {
    description = "ISP tool & library for Bouffalo Labs RISC-V Microcontrollers and SoCs";
    license = licenses.mit;
    homepage = "https://github.com/pine64/blisp";
    maintainers = [ maintainers.fortuneteller2k ];
  };
}
# TODO: update when next stable release supports building without vendored
# libraries
