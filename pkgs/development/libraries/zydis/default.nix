{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zydis";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-WSBi8HUVj/JR0/0pBoEaUKD0kOk41gSW5ZW74fn8b4k=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://zydis.re/";
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = licenses.mit;
    maintainers = with maintainers; [ jbcrail AndersonTorres ];
    platforms = platforms.all;
  };
}
