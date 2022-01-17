{ lib, stdenv, fetchFromGitHub, cmake, python3, zlib }:

stdenv.mkDerivation rec {
  pname = "seasocks";
  version = "1.4.4";

  src = fetchFromGitHub {
    owner = "mattgodbolt";
    repo = pname;
    rev = "v${version}";
    sha256 = "1f9a3mx3yjmr5qry4rc1c7mrx3348iifxm7d8sj8yd41kqnzmfv4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib python3 ];

  meta = with lib; {
    homepage = "https://github.com/mattgodbolt/seasocks";
    description = "Tiny embeddable C++ HTTP and WebSocket server";
    license = licenses.bsd2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ fredeb ];
  };
}
