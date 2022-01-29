{ lib, stdenv, fetchFromGitHub, openssl, cmake }:

stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "3.10.27";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = version;
    sha256 = "0xqcgwb1lyc2d8834sq5adbmggyn6vvb26jw20862sxa15j0qfd4";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/Makefile \
        --replace -Wl,-soname, -Wl,-install_name,$out/lib/
  '';

  meta = {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.all;
  };
}
