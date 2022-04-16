{ lib, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "0cy79swgdbaf3zmsaqa6gz3b0fad2yqawwcnsipnpl9d8hn1linm";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATCC_INSTALL=on"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  NIX_CFLAGS_COMPILE = [
    "-Wno-error=misleading-indentation"
    "-Wno-error=stringop-overflow"
  ];

  meta = {
    description = "FlatBuffers Compiler and Library in C for C ";
    homepage = "https://github.com/dvidelabs/flatcc";
    license = [ lib.licenses.asl20 ];
  };
}
