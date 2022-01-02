{ stdenv, lib, fetchFromGitHub, nymphrpc, poco }:

stdenv.mkDerivation rec {
  pname = "libnymphcast";
  version = "0.1-beta0";

  src = fetchFromGitHub {
    owner = "MayaPosch";
    repo = "libnymphcast";
    rev = "v${version}";
    sha256 = "sha256-+3V5ujwamh9SQSBY+P1WHldatsbGzqBwJ6xY6ZN4FJc=";
  };

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  buildInputs = [ nymphrpc poco ];

  meta = with lib; {
    description = "A library containing the core functionality for a NymphCast client";
    homepage = "https://github.com/MayaPosch/libnymphcast";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ aanderse ];
    platforms = platforms.unix;
  };
}
