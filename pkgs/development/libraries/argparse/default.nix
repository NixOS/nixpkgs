{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "argparse";
  version = "2.6";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "argparse";
    rev = "v${version}";
    sha256 = "sha256-imLDuVbzkiE5hcQVarZGeNzNZE0/8LHMQqAiUYzPVks=";
  };

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    description = "Argument Parser for Modern C++";
    homepage    = "https://github.com/p-ranav/argparse";
    maintainers = with maintainers; [ _2gn ];
    platforms   = platforms.unix;
    license = licenses.mit;
  };
}
