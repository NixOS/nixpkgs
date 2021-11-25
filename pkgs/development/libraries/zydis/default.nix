{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "zydis";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "zyantific";
    repo = "zydis";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-1XGELwMuFlIt6Z3+kfD6VAgDZOwhhCSG42dkYh7WLf8=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Fast and lightweight x86/x86-64 disassembler library";
    license = licenses.mit;
    maintainers = [ maintainers.jbcrail ];
    platforms = platforms.all;
  };
}
