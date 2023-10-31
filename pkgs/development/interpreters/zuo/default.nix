{ lib, stdenv, fetchFromGitHub, unstableGitUpdater }:

stdenv.mkDerivation rec {
  pname = "zuo";
  version = "unstable-2023-10-17";

  src = fetchFromGitHub {
    owner = "racket";
    repo = "zuo";
    rev = "493e9cd08147add01bba9247f36759f095b87678";
    hash = "sha256-gsCjB3V+A0kMZJZ9onZ57R6b1Ha0K+Q383DQoVGfY7I=";
  };

  doCheck = true;

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "A Tiny Racket for Scripting";
    homepage = "https://github.com/racket/zuo";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ maintainers.marsam ];
  };
}
