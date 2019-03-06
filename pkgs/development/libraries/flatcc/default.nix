{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "sha256:0cb6s9q1cbigss1q7dra0ix2a0iqlh2xxwncbrnmqv17h4lwvglr";
  };

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    "-DFLATCC_INSTALL=on"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  meta = {
    description = "FlatBuffers Compiler and Library in C for C ";
    homepage = https://github.com/dvidelabs/flatcc;
    license = [ stdenv.lib.licenses.asl20 ];
  };
}
