{ stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "flatcc";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "dvidelabs";
    repo = "flatcc";
    rev = "v${version}";
    sha256 = "06wnwvnkhw1rk0y3nncjmcyjy3bgpw8i9xqd5gpbhbrm38718cjk";
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
