{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "argparse";
  version = "2.9";

  src = fetchFromGitHub {
    owner = "p-ranav";
    repo = "argparse";
    rev = "v${version}";
    sha256 = "sha256-vbf4kePi5gfg9ub4aP1cCK1jtiA65bUS9+5Ghgvxt/E=";
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
