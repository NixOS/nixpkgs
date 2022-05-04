{ lib, stdenv, fetchFromGitHub, cmake, python3, zlib, catch2 }:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f9a3mx3yjmr5qry4rc1c7mrx3348iifxm7d8sj8yd41kqnzmfv4";
  };

  postPatch = ''
    cp ${catch2}/include/catch2/catch.hpp src/test/c/catch/catch2/catch.hpp
  '';

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python3 ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/mattgodbolt/seasocks";
    description = "Tiny embeddable C++ HTTP and WebSocket server";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fredeb ];
  };
}
