{ lib, stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "3.10.26";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = "f2094522b3940fd361ed9799bd0fcf4ba2b84988";
    sha256 = "8fURQdKr7uVDykDILlxKTxi7DXPqo5UdpOLlhwbWl2w=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ luc65r ];
    platforms = platforms.all;
  };
}
