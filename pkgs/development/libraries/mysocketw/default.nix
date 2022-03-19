{ lib, stdenv, fetchFromGitHub, openssl, cmake }:

stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = version;
    sha256 = "sha256-mpfhmKE2l59BllkOjmURIfl17lAakXpmGh2x9SFSaAo=";
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
