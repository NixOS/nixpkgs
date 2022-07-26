{ lib
, stdenv
, fetchFromGitHub
, openssl
, cmake
}:

stdenv.mkDerivation rec {
  pname = "mysocketw";
  version = "3.11.0";

  src = fetchFromGitHub {
    owner = "RigsOfRods";
    repo = "socketw";
    rev = version;
    hash = "sha256-mpfhmKE2l59BllkOjmURIfl17lAakXpmGh2x9SFSaAo=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    openssl
  ];

  postPatch = lib.optionalString stdenv.isDarwin ''
    substituteInPlace src/Makefile \
        --replace -Wl,-soname, -Wl,-install_name,$out/lib/
  '';

  meta = with lib; {
    description = "Cross platform (Linux/FreeBSD/Unix/Win32) streaming socket C++";
    homepage = "https://github.com/RigsOfRods/socketw";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ ];
  };
}
