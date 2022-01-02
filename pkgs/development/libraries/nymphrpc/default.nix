{ stdenv, lib, fetchFromGitHub, poco }:

stdenv.mkDerivation rec {
  pname = "NymphRPC";
  version = "0.1-alpha1";

  src = fetchFromGitHub {
    owner = "MayaPosch";
    repo = "NymphRPC";
    rev = "v${version}";
    sha256 = "sha256-UkCO/dPJBero/RLGs3CAuwasLhql1g3mVwKpmPkIXQY=";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  buildInputs = [ poco ];

  meta = with lib; {
    description = "A compact, C++-based Remote Procedure Call (RPC) library";
    homepage = "https://github.com/MayaPosch/NymphRPC";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.unix;
  };
}
