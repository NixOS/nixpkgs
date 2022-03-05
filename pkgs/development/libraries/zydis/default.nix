{ lib
, stdenv
, fetchFromGitHub
, cmake
}:

stdenv.mkDerivation rec {
  pname = "zydis";
  version = "3.2.1";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-FB7hGQ9vI3ZE376iROEpdtZm91IiccBhtAFa94JgnUY=";
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
